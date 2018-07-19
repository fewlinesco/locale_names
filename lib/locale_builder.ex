defmodule LocaleBuilder do
  alias Kaur.Result

  def locale_name(locale) do
    locale
    |> language_from_locale()
    |> Result.and_then(&get_display_names/1)
    |> Result.and_then(&display_name(&1, locale))
  end

  defp capitalize(nil), do: nil

  defp capitalize(string) do
    {first, rest} = String.split_at(string, 1)
    String.upcase(first) <> rest
  end

  defp display_name(display_names, locale) do
    display_names
    |> display_name_from_locale(locale)
    |> Result.or_else(fn
      :locale_not_found ->
        display_name_from_language(display_names, locale)

      error ->
        Result.error(error)
    end)
  end

  defp display_name_from_language(display_names, locale) do
    locale
    |> language_from_locale()
    |> Result.and_then(&fetch(display_names, &1, :language_does_not_exist))
    |> Result.map(&capitalize/1)
  end

  defp display_name_from_locale(display_names, locale) do
    display_names
    |> fetch(locale, :locale_not_found)
    |> Result.map(&capitalize/1)
  end

  defp fetch(map, key, error) do
    case Map.fetch(map, key) do
      :error -> Result.error(error)
      {:ok, result} -> Result.ok(result)
    end
  end

  defp language_from_locale(locale) do
    locale
    |> String.split("-")
    |> Enum.at(0)
    |> Result.from_value()
  end

  defp get_display_names(language) do
    language
    |> get_directory()
    |> File.read()
    |> Result.map_error(fn
      :enoent -> :locale_does_not_exist
      error -> error
    end)
    |> Result.map(&Poison.decode!/1)
    |> Result.map(&get_in(&1, ["main", language, "localeDisplayNames", "languages"]))
  end

  defp get_directory(language) do
    "priv/cldr-localenames-full/main/#{language}/languages.json"
  end
end
