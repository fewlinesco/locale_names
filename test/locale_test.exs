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

    assert french_locale == Locale.locale("fr-FR")
    assert french_canadian_locale == Locale.locale("fr-CA")
    assert azerbaijani_iraq_locale == Locale.locale("az-Arab")
    assert azerbaijani_locale == Locale.locale("az-AZ")
  end
end
