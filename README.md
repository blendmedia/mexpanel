# Mexpanel

API wrapper for [Mixpanel](https://mixpanel.com)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mexpanel` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mexpanel, "~> 0.1.0"}
  ]
end
```

## Usage

Mixpanel provides 2 endpoints: [track](https://mixpanel.com/help/reference/http#tracking-via-http) and [engage](https://mixpanel.com/help/reference/http#people-analytics-updates).

For both these endpoints, this library provides a struct with [builder functions](https://medium.com/kkempin/builder-design-pattern-in-elixir-c841e7cea307). The `new` function expects all mandatory parameters, additional properties can be set with functions

### Track

```elixir
alias Mexpanel.TrackRequest
track = TrackRequest.new("123", "user signed up", %{name: "Leif Gensert"})
          |> TrackRequest.time(DateTime.utc_now())
          |> TrackRequest.ip("144.10.58.141")
          |> TrackRequest.distinct_id("user:1")

Mexpanel.request(track)
```

### Engage

For the engage endpoint you will need to specify an operation. See the [official documentation](https://mixpanel.com/help/reference/http#update-operations) for all available operations.

```elixir
alias Mexpanel.EngageRequest
engage = EngageRequest.new("123", "user:1")
          |> EngageRequest.time(DateTime.utc_now())
          |> EngageRequest.ip("144.10.58.141")
          |> EngageRequest.set(%{name: "Leif Gensert"})

Mexpanel.request(engage)
```
