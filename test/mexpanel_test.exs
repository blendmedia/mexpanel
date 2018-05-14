defmodule MexpanelTest do
  use ExUnit.Case
  doctest Mexpanel

  alias Mexpanel.TrackRequest
  alias Mexpanel.EngageRequest

  @mixpanel_token "710796f2336a483e81b065588f00f2e0"

  setup do
    Application.put_env(:tesla, Mexpanel.Client, adapter: :mock)
    Application.put_env(:mexpanel, :token, @mixpanel_token)

    Tesla.Mock.mock(fn
      %{method: :post, url: "http://api.mixpanel.com/track", body: body} ->
        data = deserialize(body)
        assert data["event"] == "Signed Up"
        properties = data["properties"]
        assert properties["distinct_id"] == "user:123"
        assert properties["token"] == @mixpanel_token
        assert properties["first_name"] == "Leif"
        assert properties["last_name"] == "Gensert"
        assert properties["email"] == "leif@leif.io"
        %Tesla.Env{status: 200, body: "{\"status\": 1, \"error\": null}"}

      %{method: :post, url: "http://api.mixpanel.com/engage", body: body} ->
        data = deserialize(body)
        assert data["$token"] == @mixpanel_token
        assert data["$distinct_id"] == "user:123"
        properties = data["$set"]
        assert properties["first_name"] == "Leif"
        assert properties["last_name"] == "Gensert"
        assert properties["email"] == "leif@leif.io"
        %Tesla.Env{status: 200, body: "{\"status\": 1, \"error\": null}"}

      _other ->
        %Tesla.Env{status: 500, body: "0"}
    end)

    :ok
  end

  describe "track" do
    test "sends the right messages" do
      result =
        TrackRequest.new(@mixpanel_token, "Signed Up", %{
          first_name: "Leif",
          last_name: "Gensert",
          email: "leif@leif.io"
        })
        |> TrackRequest.distinct_id("user:123")
        |> Mexpanel.request()

      assert result == :ok
    end
  end

  describe "engage" do
    test "sends the right messages" do
      result =
        EngageRequest.new(@mixpanel_token, "user:123")
        |> EngageRequest.set(%{first_name: "Leif", last_name: "Gensert", email: "leif@leif.io"})
        |> Mexpanel.request()

      assert result == :ok
    end
  end

  defp deserialize(body) do
    body
    |> URI.decode_query()
    |> Map.get("data")
    |> Base.url_decode64!()
    |> Jason.decode!()
  end
end
