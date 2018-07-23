defmodule LocaleBuilderTest do
  use ExUnit.Case
  doctest LocaleBuilder

  test "all_locales: should return a list of all locales" do
    all_locales = LocaleBuilder.all_locales()
    assert Enum.member?(all_locales, "fr")
    assert Enum.member?(all_locales, "fr-FR")
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
      locale: "fr-FR",
      name: "Français",
      direction: :left_to_right
    }

    french_canadian_locale = %Locale{
      locale: "fr-CA",
      name: "Français canadien",
      direction: :left_to_right
    }

    azerbaijani_iraq_locale = %Locale{
      locale: "az-Arab",
      name: "Cənubi azərbaycan",
      direction: :right_to_left
    }

    azerbaijani_locale = %Locale{
      locale: "az-AZ",
      name: "Azərbaycan",
      direction: :left_to_right
    }

    assert {:ok, french_locale} == LocaleBuilder.locale("fr-FR")
    assert {:ok, french_canadian_locale} == LocaleBuilder.locale("fr-CA")
    assert {:ok, azerbaijani_iraq_locale} == LocaleBuilder.locale("az-Arab")
    assert {:ok, azerbaijani_locale} == LocaleBuilder.locale("az-AZ")
  end

  test "locale: should return an error wih a unvalid locale" do
    assert {:error, :locale_does_not_exist} == LocaleBuilder.locale("not a locale")
  end
end
