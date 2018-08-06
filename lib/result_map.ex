defmodule Kaur.Result.Map do
  alias Kaur.Result

  def fetch(map, key, error_reason) do
    case Map.fetch(map, key) do
      :error -> Result.error(error_reason)
      result -> result
    end
  end

  def fetch_first(map, keys, reason \\ :key_not_found)

  def fetch_first(_map, [], reason), do: Result.error(reason)

  def fetch_first(map, [head | tail], reason) do
    case Map.fetch(map, head) do
      :error -> fetch_first(map, tail, reason)
      result -> result
    end
  end
end
