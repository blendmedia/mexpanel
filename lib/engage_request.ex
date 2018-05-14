defmodule Mexpanel.EngageRequest do
  @enforce_keys [:token, :distinct_id]

  defstruct [
    :token,
    :distinct_id,
    :time,
    :ip,
    :ignore_time,
    :operation,
    :properties
  ]

  @type properties :: map() | list() | nil

  @type operation ::
          :set
          | :set_once
          | :add
          | :append
          | :union
          | :remove
          | :unset
          | :delete

  @type t :: %__MODULE__{
          token: String.t(),
          distinct_id: String.t(),
          time: DateTime.t(),
          ip: String.t(),
          ignore_time: boolean,
          operation: operation,
          properties: properties
        }

  @spec new(String.t(), String.t()) :: t
  def new(token, distinct_id) do
    %__MODULE__{
      token: token,
      distinct_id: distinct_id
    }
  end

  @spec time(t, String.t()) :: t
  def time(request, time) do
    %{request | time: time}
  end

  @spec ip(t, String.t()) :: t
  def ip(request, ip) do
    %{request | ip: ip}
  end

  @spec ignore_time(t) :: t
  def ignore_time(request) do
    %{request | ignore_time: true}
  end

  ### Operations

  @spec set(t, properties) :: t
  def set(request, properties) do
    %{request | operation: :set, properties: properties}
  end

  @spec set_once(t, properties) :: t
  def set_once(request, properties) do
    %{request | operation: :set_once, properties: properties}
  end

  @spec add(t, properties) :: t
  def add(request, properties) do
    %{request | operation: :add, properties: properties}
  end

  @spec append(t, properties) :: t
  def append(request, properties) do
    %{request | operation: :append, properties: properties}
  end

  @spec union(t, properties) :: t
  def union(request, properties) do
    %{request | operation: :union, properties: properties}
  end

  @spec remove(t, properties) :: t
  def remove(request, properties) do
    %{request | operation: :remove, properties: properties}
  end

  @spec unset(t, properties) :: t
  def unset(request, properties) do
    %{request | operation: :unset, properties: properties}
  end

  @spec delete(t) :: t
  def delete(request) do
    %{request | operation: :delete, properties: nil}
  end
end
