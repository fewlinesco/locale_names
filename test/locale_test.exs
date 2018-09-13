defmodule LocaleTest do
  use ExUnit.Case

  doctest Locale

  test "locale?: should return true with a correct locale" do
    assert Locale.locale?("fr-FR")
    assert Locale.locale?("en-US")
    assert Locale.locale?("ja-JP")
  end

  test "locale?: should return false with an incorrect locale" do
    refute Locale.locale?("not a locale")
  end

  test "locale: should return a Locale struct" do
    french_locale = %Locale{
      direction: :left_to_right,
      english_name: "French",
      locale_code: "fr-FR",
      name: "Français"
    }

    french_canadian_locale = %Locale{
      direction: :left_to_right,
      english_name: "Canadian French",
      locale_code: "fr-CA",
      name: "Français canadien"
    }

    azerbaijani_iraq_locale = %Locale{
      direction: :right_to_left,
      english_name: "Azerbaijani",
      locale_code: "az-Arab",
      name: "Cənubi azərbaycan"
    }

    azerbaijani_locale = %Locale{
      direction: :left_to_right,
      english_name: "Azerbaijani",
      locale_code: "az-AZ",
      name: "Azərbaycan"
    }

    assert {:ok, french_locale} == Locale.locale("fr-FR")
    assert {:ok, french_canadian_locale} == Locale.locale("fr-CA")
    assert {:ok, azerbaijani_iraq_locale} == Locale.locale("az-Arab")
    assert {:ok, azerbaijani_locale} == Locale.locale("az-AZ")
  end
end
