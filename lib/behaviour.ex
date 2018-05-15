defmodule Mexpanel.Behaviour do
  @type request :: Mexpanel.TrackRequest.t() | Mexpanel.EngageRequest.t()
  @type api_return :: :ok | {:error, reason :: String.t()}

  @callback request(request) :: api_return
end
