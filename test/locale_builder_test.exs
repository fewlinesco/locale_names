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

  test "locale: should return a struct with all locale info" do
    french_locale = %LocaleBuilder{
      locale: "fr-FR",
      name: "Français",
      direction: :left_to_right
    }

    azerbaijani_iraq_locale = %LocaleBuilder{
      locale: "az-IQ",
      name: "Azərbaycan",
      direction: :right_to_left
    }

    azerbaijani_locale = %LocaleBuilder{
      locale: "az-AZ",
      name: "Azərbaycan",
      direction: :left_to_right
    }

    assert {:ok, french_locale} == LocaleBuilder.locale("fr-FR")
    assert {:ok, azerbaijani_iraq_locale} == LocaleBuilder.locale("az-IQ")
    assert {:ok, azerbaijani_locale} == LocaleBuilder.locale("az-AZ")
  end

  test "locale: should return an error wih a unvalid locale" do
    assert {:error, :locale_does_not_exist} == LocaleBuilder.locale("not a locale")
  end
end
