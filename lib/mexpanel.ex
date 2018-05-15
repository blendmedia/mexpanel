defmodule Mexpanel do
  alias Mexpanel.Client
  alias Mexpanel.TrackRequest
  alias Mexpanel.EngageRequest

  @behaviour __MODULE__.Behaviour

  def request(%TrackRequest{} = request) do
    data = %{
      "event" => request.event,
      "properties" =>
        Map.merge(request.properties, %{
          "distinct_id" => request.distinct_id,
          "ip" => request.ip,
          "token" => request.token,
          "time" => serialize_datetime(request.time)
        })
    }

    Client.track(data)
  end

  def request(%EngageRequest{} = request) do
    data = %{
      "$token" => request.token,
      "$distinct_id" => request.distinct_id,
      "$time" => serialize_datetime(request.time),
      "$ip" => request.ip,
      "$ignore_time" => request.ignore_time,
      "$#{request.operation}" => request.properties
    }

    Client.engage(data)
  end

  defp serialize_datetime(nil), do: nil
  defp serialize_datetime(datetime), do: DateTime.to_unix(datetime)
end
