defmodule LocaleBuilder do
  alias Kaur.Result

  def locale_direction(locale) do
    locale
    |> language_from_locale()
    |> Result.and_then(&CLDR.likely_script(&1, locale))
    |> Result.and_then(&CLDR.direction_from_script/1)
  end

  def locale_name(locale) do
    locale
    |> language_from_locale()
    |> Result.and_then(&CLDR.get_display_names/1)
    |> Result.and_then(&display_name(&1, locale))
  end

  defp capitalize(nil), do: nil

  defp capitalize(string) do
    {first, rest} = String.split_at(string, 1)
    String.upcase(first) <> rest
  end

  defp display_name(display_names, locale) do
    locale
    |> language_from_locale()
    |> Result.and_then(fn language ->
      Result.Map.fetch_first(display_names, [locale, language], :language_does_not_exist)
    end)
    |> Result.map(&capitalize/1)
  end

  defp language_from_locale(locale) do
    locale
    |> String.split("-")
    |> Enum.at(0)
    |> Result.from_value()
  end
end
