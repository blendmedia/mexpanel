defmodule Mexpanel.TrackRequest do
  @enforce_keys [:event, :token, :properties]

  defstruct [
    :event,
    :distinct_id,
    :time,
    :ip,
    :token,
    :properties
  ]

  @type t :: %__MODULE__{
          event: String.t(),
          time: DateTime.t(),
          distinct_id: String.t(),
          ip: String.t(),
          token: String.t(),
          properties: map()
        }

  @spec new(String.t(), String.t(), map()) :: t
  def new(token, event, properties) do
    %__MODULE__{
      token: token,
      event: event,
      properties: properties
    }
  end

  @spec time(t, String.t()) :: t
  def time(request, time) do
    %{request | time: time}
  end

  @spec distinct_id(t, String.t()) :: t
  def distinct_id(request, distinct_id) do
    %{request | distinct_id: distinct_id}
  end

  @spec ip(t, String.t()) :: t
  def ip(request, ip) do
    %{request | ip: ip}
  end
end
