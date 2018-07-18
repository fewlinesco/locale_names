defmodule LocaleBuilder do
  alias Kaur.Result

  def locale_name(locale) do
    language = language_from_locale(locale)

    case locale_display_names(language) do
      {:ok, display_names} ->
        case display_names[locale] do
          nil ->
            capitalize(display_names[language])

          language_name ->
            capitalize(language_name)
        end

      _ ->
        {:error, :no_locale_found}
    end
  end

  defp capitalize(nil), do: nil

  defp capitalize(string) do
    {first, rest} = String.split_at(string, 1)
    String.upcase(first) <> rest
  end

  defp locale_display_names(language) do
    language
    |> get_directory()
    |> File.read()
    |> Result.map(&Poison.decode!/1)
    |> Result.map(&get_in(&1, ["main", language, "localeDisplayNames", "languages"]))
  end

  defp get_directory(language) do
    "priv/cldr-localenames-full/main/#{language}/languages.json"
  end

  defp language_from_locale(locale) do
    locale
    |> String.split("-")
    |> Enum.at(0)
  end
end
