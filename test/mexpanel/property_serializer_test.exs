defmodule Mexpanel.PropertySerializerTest do
  use ExUnit.Case
  alias Mexpanel.PropertySerializer

  test "it removes nils" do
    input = %{first_name: "Leif", favorite_color: nil}
    assert PropertySerializer.serialize(input) == %{first_name: "Leif"}
  end

  test "it removes nested nils" do
    input = %{first_name: "Leif", favorites: %{color: nil}}
    assert PropertySerializer.serialize(input) == %{first_name: "Leif", favorites: %{}}
  end

  test "it converts DateTime in UTC to right String" do
    datetime = Timex.to_datetime({{2018, 04, 25}, {13, 36, 45}}, "UTC")
    input = %{first_name: "Leif", perfect_date: datetime}

    assert PropertySerializer.serialize(input) == %{
             first_name: "Leif",
             perfect_date: "2018-04-25T13:36:45"
           }
  end

  test "it converts DateTime in different timezone to right String" do
    datetime = Timex.to_datetime({{2018, 04, 25}, {23, 36, 45}}, "Australia/Melbourne")
    input = %{first_name: "Leif", perfect_date: datetime}

    assert PropertySerializer.serialize(input) == %{
             first_name: "Leif",
             perfect_date: "2018-04-25T13:36:45"
           }
  end

  test "it converts NaiveDatetime to right String" do
    datetime = Timex.to_naive_datetime({{2018, 04, 25}, {13, 36, 45}})
    input = %{first_name: "Leif", perfect_date: datetime}

    assert PropertySerializer.serialize(input) == %{
             first_name: "Leif",
             perfect_date: "2018-04-25T13:36:45"
           }
  end

  test "it converts time in nested map" do
    datetime = Timex.to_datetime({{2018, 04, 25}, {13, 36, 45}}, "UTC")
    input = %{first_name: "Leif", perfects: %{date: datetime}}

    assert PropertySerializer.serialize(input) == %{
             first_name: "Leif",
             perfects: %{date: "2018-04-25T13:36:45"}
           }
  end
end
