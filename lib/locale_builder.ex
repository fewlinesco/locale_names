defmodule LocaleBuilder do
  @spec all_locales() :: list(Locale.locale_code())
  def all_locales do
    CLDR.available_locales()
    |> Enum.reduce([], fn locale, acc ->
      if String.contains?(locale, "-") do
        [locale | acc]
      else
        [locale <> "-" <> String.upcase(locale) | [locale | acc]]
      end
    end)
  end

  @spec locale?(Locale.locale_code()) :: boolean()
  def locale?(locale) do
    Enum.member?(all_locales(), locale)
  end

  @spec locale(Locale.locale_code()) :: Locale.locale() | {:error, String.t()}
  def locale(locale) do
    with {:ok, direction} <- locale_direction(locale),
         {:ok, name} <- locale_name(locale) do
      %Locale{
        locale: locale,
        direction: direction,
        name: name
      }
    else
      error -> error
    end
  end

  @spec locale_direction(Locale.locale_code()) ::
          {:ok, CLDR.direction_type()} | {:error, :locale_not_found}
  def locale_direction(locale) do
    with language = language_from_locale(locale),
         {:ok, script} <- CLDR.likely_script(language, locale),
         direction <- CLDR.direction_from_script(script) do
      {:ok, direction}
    else
      error -> error
    end
  end

  @spec locale_name(Locale.locale_code()) :: {:ok, String.t()} | {:error, :locale_not_found}
  def locale_name(locale) do
    display_names =
      locale
      |> language_from_locale()
      |> CLDR.get_display_names()

    case display_names do
      {:error, :locale_not_found} = error -> error
      name_map -> {:ok, display_name(name_map, locale)}
    end
  end

  @spec capitalize(String.t()) :: String.t() | nil
  defp capitalize(nil), do: nil

  defp capitalize(string) do
    {first, rest} = String.split_at(string, 1)
    String.upcase(first) <> rest
  end

  @spec display_name(%{}, Locale.locale_code()) :: String.t() | :language_not_found
  defp display_name(display_names, locale) do
    language = language_from_locale(locale)

    case Map.Extra.fetch_first(display_names, [locale, language], :language_not_found) do
      {:error, :language_not_found} -> :language_not_found
      {:ok, name} -> capitalize(name)
    end
  end

  @spec language_from_locale(Locale.locale_code()) :: CLDR.language() | nil
  defp language_from_locale(locale) do
    locale
    |> String.split("-")
    |> Enum.at(0)
  end
end
