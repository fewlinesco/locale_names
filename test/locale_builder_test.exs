defmodule LocaleBuilderTest do
  use ExUnit.Case
  doctest LocaleBuilder

  test "all_locales: should return a list of all locales" do
    all_locales = LocaleBuilder.all_locales()
    assert Enum.member?(all_locales, "fr")
    assert Enum.member?(all_locales, "fr-FR")
  end

  test "english_locale_name: should get the name of a locale in english" do
    assert {:ok, "Azerbaijani"} == LocaleBuilder.english_locale_name("az")
    assert {:ok, "French"} == LocaleBuilder.english_locale_name("fr-FR")
  end

  test "locale?: should return a boolean if a locale exist" do
    assert LocaleBuilder.locale?("fr-FR")
    assert LocaleBuilder.locale?("az-AZ")
    refute LocaleBuilder.locale?("not a locale")
  end

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
    assert {:ok, :right_to_left} == LocaleBuilder.locale_direction("az-Arab")
  end

  test "locale: should return a struct with all locale info" do
    french_locale = %Locale{
      direction: :left_to_right,
      english_name: "French",
      locale: "fr-FR",
      name: "Français"
    }

    french_canadian_locale = %Locale{
      direction: :left_to_right,
      english_name: "Canadian French",
      locale: "fr-CA",
      name: "Français canadien"
    }

    azerbaijani_iraq_locale = %Locale{
      direction: :right_to_left,
      english_name: "Azerbaijani",
      locale: "az-Arab",
      name: "Cənubi azərbaycan"
    }

    azerbaijani_locale = %Locale{
      direction: :left_to_right,
      english_name: "Azerbaijani",
      locale: "az-AZ",
      name: "Azərbaycan"
    }

    assert french_locale == LocaleBuilder.locale("fr-FR")
    assert french_canadian_locale == LocaleBuilder.locale("fr-CA")
    assert azerbaijani_iraq_locale == LocaleBuilder.locale("az-Arab")
    assert azerbaijani_locale == LocaleBuilder.locale("az-AZ")
  end

  test "locale: should return an error wih a unvalid locale" do
    assert {:error, :locale_not_found} == LocaleBuilder.locale("not a locale")
  end
end
