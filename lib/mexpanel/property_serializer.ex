defmodule Mexpanel.PropertySerializer do
  def serialize(properties) do
    properties
    |> remove_nils()
    |> cast()
  end

  defp remove_nils(properties) do
    compactor = fn {k, v}, acc ->
      cond do
        is_map(v) and Map.has_key?(v, :__struct__) -> Map.put_new(acc, k, v)
        is_map(v) && Enum.empty?(v) -> acc
        is_map(v) -> Map.put_new(acc, k, remove_nils(v))
        is_nil(v) -> acc
        true -> Map.put_new(acc, k, v)
      end
    end

    Enum.reduce(properties, %{}, compactor)
  end

  defp cast(properties) do
    properties
    |> Enum.map(&cast_value/1)
    |> Enum.into(%{})
  end

  defp cast_value({key, %DateTime{} = datetime}) do
    {key, format_time(datetime)}
  end

  defp cast_value({key, %NaiveDateTime{} = naive_datetime}) do
    {key, format_time(naive_datetime)}
  end

  defp cast_value({key, %{} = map}) do
    {key, serialize(map)}
  end

  defp cast_value(fallback), do: fallback

  defp format_time(datetime) do
    datetime
    |> Timex.to_datetime(:utc)
    |> Timex.format!("%Y-%m-%dT%H:%M:%S", :strftime)
  end
end
