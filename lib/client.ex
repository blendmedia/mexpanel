defmodule Mexpanel.Client do
  use Tesla
  plug Tesla.Middleware.BaseUrl, "http://api.mixpanel.com"
  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.DebugLogger

  def track(data) do
    post("/track", %{data: serialize(data)})
  end

  def engage(data) do
    post("/engage", %{data: serialize(data), verbose: "1"})
  end

  defp serialize(data) do
    data
      |> Jason.encode!()
      |> Base.url_encode64(padding: false)
  end
end
