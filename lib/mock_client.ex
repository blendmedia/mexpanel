defmodule Mexpanel.MockClient do
  def track(_data), do: :ok
  def engage(_data), do: :ok
end
