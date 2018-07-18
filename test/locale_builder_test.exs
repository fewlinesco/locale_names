defmodule LocaleBuilderTest do
  use ExUnit.Case
  doctest LocaleBuilder

  test "locale_name: should get the name of a locale in its language" do
    assert "British English" == LocaleBuilder.locale_name("en-GB")
    assert "American English" == LocaleBuilder.locale_name("en-US")
  end

  test "locale_name: should get the name of the language if locale is not found" do
    assert "English" == LocaleBuilder.locale_name("en-EN")
    assert "Français" == LocaleBuilder.locale_name("fr-FR")
  end

  test "locale_name: should error when passed an unvalid locale" do
    assert {:error, :no_locale_found} == LocaleBuilder.locale_name("not a locale")
  end
end
