defmodule Map.Extra do
  def fetch(map, key, error_reason) do
    case Map.fetch(map, key) do
      :error -> {:error, error_reason}
      result -> result
    end
  end

  def fetch_first(map, keys, error_reason) do
    case keys do
      [] ->
        {:error, error_reason}

      [key | rest] ->
        case fetch(map, key, error_reason) do
          {:ok, result} -> {:ok, result}
          {:error, ^error_reason} -> fetch_first(map, rest, error_reason)
          error -> error
        end
    end
  end
end
