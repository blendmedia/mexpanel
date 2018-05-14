defmodule Mexpanel.TrackRequestTest do
  use ExUnit.Case
  alias Mexpanel.TrackRequest

  describe "new" do
    test "creates the right struct" do
      assert %{token: "123", event: "user signed up", properties: %{all: :custom}} =
               TrackRequest.new("123", "user signed up", %{all: :custom})
    end
  end

  describe "distinct_id" do
    test "modifies the struct in the right way" do
      initial_struct = %TrackRequest{
        token: "123",
        event: "user signed up",
        properties: %{},
        distinct_id: nil
      }

      distinct_id = "user:123"
      changed = TrackRequest.distinct_id(initial_struct, distinct_id)
      assert changed.distinct_id == distinct_id
    end
  end

  describe "time" do
    test "modifies the struct in the right way" do
      initial_struct = %TrackRequest{
        token: "123",
        event: "user signed up",
        properties: %{},
        time: nil
      }

      time = DateTime.utc_now()
      changed = TrackRequest.time(initial_struct, time)
      assert changed.time == time
    end
  end

  describe "ip" do
    test "modifies the struct in the right way" do
      initial_struct = %TrackRequest{
        token: "123",
        event: "user signed up",
        properties: %{},
        ip: nil
      }

      ip = "144.10.58.141"
      changed = TrackRequest.ip(initial_struct, ip)
      assert changed.ip == ip
    end
  end
end
