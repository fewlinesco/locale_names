defmodule LocaleTest do
  use ExUnit.Case

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

    assert french_locale == Locale.locale("fr-FR")
    assert french_canadian_locale == Locale.locale("fr-CA")
    assert azerbaijani_iraq_locale == Locale.locale("az-Arab")
    assert azerbaijani_locale == Locale.locale("az-AZ")
  end
end
