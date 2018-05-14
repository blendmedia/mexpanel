defmodule Mexpanel.Client do
  use Tesla
  plug Tesla.Middleware.BaseUrl, "http://api.mixpanel.com"
  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.DebugLogger

  def track(data) do
    post("/track", %{data: serialize(data), verbose: "1"}) |> handle_http()
  end

  def engage(data) do
    post("/engage", %{data: serialize(data), verbose: "1"}) |> handle_http()
  end

  defp handle_http(%{status: 200, body: body}) do
    case Jason.decode(body) do
      {:ok, %{"status" => 1}} -> :ok
      {:ok, %{"status" => 0, "error" => reason}} -> {:error, "Mixpanel API Error: #{reason}"}
      {:error, _} -> {:error, "JSON Error"}
      other -> {:error, "Unknown Error"}
    end
  end

  defp handle_http(%{status: http_error_status, body: body}) do
    {:error, "HTTP Error (#{http_error_status}): #{body}"}
  end

  defp serialize(data) do
    data
      |> Jason.encode!()
      |> Base.url_encode64()
  end
end
