defmodule Mexpanel.Client do
  alias Mexpanel.PropertySerializer

  use Tesla
  plug(Tesla.Middleware.BaseUrl, "https://api.mixpanel.com")
  plug(Tesla.Middleware.FormUrlencoded)

  def track(data) do
    post("/track", %{data: serialize(data), verbose: "1"}) |> handle_http()
  end

  def engage(data) do
    post("/engage", %{data: serialize(data), verbose: "1"}) |> handle_http()
  end

  defp handle_http({:ok, %{status: 200, body: body}}) do
    case Jason.decode(body) do
      {:ok, %{"status" => 1}} -> :ok
      {:ok, %{"status" => 0, "error" => reason}} -> {:error, "Mixpanel API Error: #{reason}"}
      {:error, _} -> {:error, "Mixpanel JSON Error"}
      other -> {:error, "Unknown Mixpanel Error (#{other})"}
    end
  end

  defp handle_http({:ok, %{status: http_error_status, body: body}}) do
    {:error, "HTTP Error (#{http_error_status}): #{body}"}
  end

  defp handle_http({:error, reason}) do
    {:error, "HTTP Error: #{reason}"}
  end

  defp serialize(data) do
    data
    |> PropertySerializer.serialize()
    |> Jason.encode!()
    |> Base.url_encode64()
  end
end
