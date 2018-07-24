defmodule CLDRTest do
  use ExUnit.Case
  doctest CLDR

  test "direction_from_script: should return a direction from a script" do
    assert {:ok, :left_to_right} == CLDR.direction_from_script("Latn")
    assert {:ok, :right_to_left} == CLDR.direction_from_script("Arab")
  end

  test "direction_from_script: should error for a made up script" do
    assert {:error, :script_not_found} == CLDR.direction_from_script("not a script")
  end

  test "direction_from_script: should return unknown for unknown script" do
    assert {:ok, :unknown_direction} == CLDR.direction_from_script("Zzzz")
  end

  test "get_display_names: should return a list of languages" do
    assert {:ok, language_map} = CLDR.get_display_names("fr")
    assert "français" == language_map["fr"]
    assert "swahili du Congo" == language_map["sw-CD"]
  end

  test "get_display_names: should error with an invalid language" do
    assert {:error, :locale_not_found} == CLDR.get_display_names("not a language")
  end

  test "likely_script: should return the most likely script for a language" do
    assert {:ok, "Latn"} == CLDR.likely_script("fr")
    assert {:ok, "Cyrl"} == CLDR.likely_script("ru")
    assert {:ok, "Latn"} == CLDR.likely_script("az")
    assert {:ok, "Arab"} == CLDR.likely_script("az", "az-IQ")
  end

  test "likely_script: should error with an invalid language" do
    assert {:error, :locale_not_found} == CLDR.likely_script("not a language")
  end
end
