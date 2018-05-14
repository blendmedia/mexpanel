defmodule Mexpanel do
  alias Mexpanel.Client
  alias Mexpanel.TrackRequest
  alias Mexpanel.EngageRequest
  @type operation ::
          :set
          | :set_once
          | :add
          | :append
          | :union
          | :remove
          | :unset
          | :delete

  @callback track(
              distinct_id :: String.t(),
              event_name :: String.t(),
              properties :: map(),
              options :: Keyword.t()
            ) :: map()
  @callback engage(
              distinct_id :: String.t(),
              metadata :: map(),
              operation :: operation,
              properties :: map(),
              options :: Keyword.t()
            ) :: map()

  @behaviour __MODULE__

  def track(distinct_id, event_name, properties, _options \\ []) do
    data = %{
      event: event_name,
      properties: Map.merge(properties, %{distinct_id: distinct_id, token: api_token()})
    }

    case Client.track(data) do
      %{body: "1"} -> :ok
      _ -> :error
    end
  end

  def engage(distinct_id, _metadata, operation, properties, _options \\ []) do
    data = %{
      "$token" => api_token(),
      "$distinct_id" => distinct_id,
      "$#{operation}" => properties,
    }

    case Client.engage(data) do
      %{body: "1"} -> :ok
      _ -> :error
    end
  end

  def request(%TrackRequest{} = request) do
    data = %{
      event: request.event,
      properties: Map.merge(request.properties, %{distinct_id: request.distinct_id, token: request.token})
    }

    Client.track(data)
  end

  def request(%EngageRequest{} = request) do
    data = %{
      "$token" => request.token,
      "$distinct_id" => request.distinct_id,
      "$#{request.operation}" => request.properties,
    }

    Client.engage(data)
  end

  defp api_token do
    Application.get_env(:mexpanel, :token)
  end
end
