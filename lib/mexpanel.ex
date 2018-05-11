defmodule Mexpanel do
  alias Mexpanel.Client
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

  defp api_token do
    Application.get_env(:mexpanel, :token)
  end
end
