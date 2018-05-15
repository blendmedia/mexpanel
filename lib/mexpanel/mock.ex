defmodule Mexpanel.Mock do
  @behaviour Mexpanel.Behaviour

  def request(_request), do: :ok
end
