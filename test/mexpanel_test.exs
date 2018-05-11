defmodule MexpanelTest do
  use ExUnit.Case
  doctest Mexpanel

  @mixpanel_token "710796f2336a483e81b065588f00f2e0"

  setup do
    Application.put_env :tesla, Mexpanel.Client, adapter: :mock
    Application.put_env :mexpanel, :token, @mixpanel_token
    Tesla.Mock.mock fn
      %{method: :post, url: "http://api.mixpanel.com/track", body: "data=" <> data} ->
        data = deserialize(data)
        assert data["event"] == "Signed Up"
        properties = data["properties"]
        assert properties["distinct_id"] == "123"
        assert properties["token"] == @mixpanel_token
        assert properties["first_name"] == "Leif"
        assert properties["last_name"] == "Gensert"
        assert properties["email"] == "leif@leif.io"
        %Tesla.Env{status: 200, body: "{\"status\": 1, \"error\": null}"}
      %{method: :post, url: "http://api.mixpanel.com/engage", body: "data=" <> data} ->
          data = deserialize(data)
          assert data["$token"] == @mixpanel_token
          assert data["$distinct_id"] == "123"
          properties = data["$set"]
          assert properties["first_name"] == "Leif"
          assert properties["last_name"] == "Gensert"
          assert properties["email"] == "leif@leif.io"
          %Tesla.Env{status: 200, body: "{\"status\": 1, \"error\": null}"}
      _other ->
        %Tesla.Env{status: 500, body: "0"}
    end

    :ok
  end

  describe "track" do
    test "sends the right messages" do
      assert Mexpanel.track("123", "Signed Up", %{first_name: "Leif", last_name: "Gensert", email: "leif@leif.io"}) == :ok
    end
  end

  describe "engage" do
    test "sends the right messages" do
      assert Mexpanel.engage("123", %{}, :set, %{first_name: "Leif", last_name: "Gensert", email: "leif@leif.io"}) == :ok
    end
  end

  defp deserialize(data) do
    data
    |> Base.url_decode64!(padding: false)
    |> Jason.decode!()
  end
end
