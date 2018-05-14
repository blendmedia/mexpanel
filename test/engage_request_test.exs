defmodule Mexpanel.EngageRequestTest do
  use ExUnit.Case
  alias Mexpanel.EngageRequest

  describe "new" do
    test "creates the right struct" do
      assert %{token: "123", distinct_id: "user:123"} = EngageRequest.new("123", "user:123")
    end
  end

  describe "time" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        time: nil
      }
      time = DateTime.utc_now
      changed = EngageRequest.time(initial_struct, time)
      assert changed.time == time
    end
  end

  describe "ip" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        ip: nil
      }
      ip = "144.10.58.141"
      changed = EngageRequest.ip(initial_struct, ip)
      assert changed.ip == ip
    end
  end

  describe "ignore_time" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        ignore_time: nil
      }
      changed = EngageRequest.ignore_time(initial_struct)
      assert changed.ignore_time == true
    end
  end

  describe "set" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        operation: nil,
        properties: nil
      }
      properties = %{all: "custom"}
      changed = EngageRequest.set(initial_struct, properties)
      assert changed.operation == :set
      assert changed.properties == properties
    end
  end

  describe "set_once" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        operation: nil,
        properties: nil
      }
      properties = %{all: "custom"}
      changed = EngageRequest.set_once(initial_struct, properties)
      assert changed.operation == :set_once
      assert changed.properties == properties
    end
  end

  describe "add" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        operation: nil,
        properties: nil
      }
      properties = %{login_count: 2}
      changed = EngageRequest.add(initial_struct, properties)
      assert changed.operation == :add
      assert changed.properties == properties
    end
  end

  describe "append" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        operation: nil,
        properties: nil
      }
      properties = %{superpowers: "Laser Eyes"}
      changed = EngageRequest.append(initial_struct, properties)
      assert changed.operation == :append
      assert changed.properties == properties
    end
  end

  describe "union" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        operation: nil,
        properties: nil
      }
      properties = %{superpowers: ["Laser Eyes", "Invisibility"]}
      changed = EngageRequest.union(initial_struct, properties)
      assert changed.operation == :union
      assert changed.properties == properties
    end
  end

  describe "remove" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        operation: nil,
        properties: nil
      }
      properties = %{superpowers: "Invisibility"}
      changed = EngageRequest.remove(initial_struct, properties)
      assert changed.operation == :remove
      assert changed.properties == properties
    end
  end

  describe "unset" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        operation: nil,
        properties: nil
      }
      properties = [:superpowers]
      changed = EngageRequest.unset(initial_struct, properties)
      assert changed.operation == :unset
      assert changed.properties == properties
    end
  end

  describe "delete" do
    test "modifies the struct in the right way" do
      initial_struct = %EngageRequest{
        token: "123",
        distinct_id: "user:123",
        operation: nil,
        properties: nil
      }
      changed = EngageRequest.delete(initial_struct)
      assert changed.operation == :delete
    end
  end
end
