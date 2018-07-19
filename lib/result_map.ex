defmodule Kaur.Result.Map do
  alias Kaur.Result

  def fetch(map, key, error_reason) do
    case Map.fetch(map, key) do
      :error -> Result.error(error_reason)
      result -> result
    end
  end

  def fetch_with_fallback(map, keys, error_reason) do
    case keys do
      [] ->
        Result.error(error_reason)

      [key] ->
        fetch(map, key, error_reason)

      [key | rest] ->
        fetch(map, key, :key_not_found)
        |> Result.or_else(fn
          :key_not_found -> fetch_with_fallback(map, rest, error_reason)
          error -> error
        end)
    end
  end
end
