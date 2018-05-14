defmodule Mexpanel.Client do
  use Tesla
  plug(Tesla.Middleware.BaseUrl, "https://api.mixpanel.com")
  plug(Tesla.Middleware.FormUrlencoded)

  def track(data) do
    properties = remove_nils(data["properties"] || data[:properties])
    data = data |> remove_nils() |> Map.put("properties", properties)
    post("/track", %{data: serialize(data), verbose: "1"}) |> handle_http()
  end

  def engage(data) do
    data = remove_nils(data)
    post("/engage", %{data: serialize(data), verbose: "1"}) |> handle_http()
  end

  defp handle_http(%{status: 200, body: body}) do
    case Jason.decode(body) do
      {:ok, %{"status" => 1}} -> :ok
      {:ok, %{"status" => 0, "error" => reason}} -> {:error, "Mixpanel API Error: #{reason}"}
      {:error, _} -> {:error, "Mixpanel JSON Error"}
      other -> {:error, "Unknown Mixpanel Error (#{other})"}
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

  defp remove_nils(nil), do: nil
  defp remove_nils(data) do
    data
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{})
  end
end
