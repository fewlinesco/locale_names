defmodule LocaleBuilderTest do
  use ExUnit.Case
  doctest LocaleBuilder

  test "locale_name: should get the name of a locale in its language" do
    assert {:ok, "British English"} == LocaleBuilder.locale_name("en-GB")
    assert {:ok, "American English"} == LocaleBuilder.locale_name("en-US")
  end

  test "locale_name: should get the name of the language if locale is not found" do
    assert {:ok, "English"} == LocaleBuilder.locale_name("en-EN")
    assert {:ok, "Français"} == LocaleBuilder.locale_name("fr-FR")
  end

  test "locale_name: should error when passed an unvalid locale" do
    assert {:error, :locale_not_found} == LocaleBuilder.locale_name("not a locale")
  end

  test "locale_direction: should get the direction of a locale" do
    assert {:ok, :left_to_right} == LocaleBuilder.locale_direction("fr-FR")
    assert {:ok, :right_to_left} == LocaleBuilder.locale_direction("fa-IR")
    assert {:ok, :left_to_right} == LocaleBuilder.locale_direction("az-AZ")
    assert {:ok, :right_to_left} == LocaleBuilder.locale_direction("az-IQ")
  end
end
