defmodule Kaur.Result.MapTest do
  use ExUnit.Case
  alias Kaur.Result
  doctest Kaur.Result.Map

  test "fetch: should work like a fetch when key exists" do
    map = %{
      my_key: "my_value"
    }

    assert {:ok, "my_value"} == Result.Map.fetch(map, :my_key, :key_does_not_exist)
  end

  test "fetch: should have a reason when key does not exist" do
    assert {:error, :key_does_not_exist} == Result.Map.fetch(%{}, :my_key, :key_does_not_exist)
  end

  test "fetch_first: should work like a fetch when one of the keys exists" do
    map = %{
      my_key: "my_value"
    }

    assert {:ok, "my_value"} ==
             Result.Map.fetch_first(
               map,
               [:non_existant_key, :my_key],
               :key_does_not_exist
             )
  end

  test "fetch: should have a reason when none of the keys exist" do
    assert {:error, :key_does_not_exist} ==
             Result.Map.fetch_first(%{}, [:key1, :key2, :key3], :key_does_not_exist)
  end
end
