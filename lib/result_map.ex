defmodule Kaur.Result.Map do
  alias Kaur.Result

  def fetch(map, key, error_reason) do
    case Map.fetch(map, key) do
      :error -> Result.error(error_reason)
      result -> result
    end
  end

  def fetch_first(map, keys, error_reason) do
    case keys do
      [] ->
        Result.error(error_reason)

      [key | rest] ->
        fetch(map, key, error_reason)
        |> Result.or_else(fn
          ^error_reason -> fetch_first(map, rest, error_reason)
          error -> error
        end)
    end
  end
end
