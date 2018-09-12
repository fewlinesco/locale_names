defmodule LocaleBuilder do
  @moduledoc false

  @spec all_locale_codes() :: list(Locale.locale_code())
  def all_locale_codes do
    CLDR.available_locales()
    |> Enum.reduce([], fn locale, acc ->
      if String.contains?(locale, "-") do
        [locale | acc]
      else
        [locale <> "-" <> String.upcase(locale) | [locale | acc]]
      end
    end)
  end

  @spec english_locale_name(Locale.locale_code()) ::
          {:ok, String.t()} | {:error, :locale_not_found}
  def english_locale_name(locale_code) do
    display_names =
      "en"
      |> language_from_locale_code()
      |> CLDR.get_display_names()

    case display_names do
      {:error, :locale_not_found} -> display_names
      name_map -> {:ok, display_name(name_map, locale_code)}
    end
  end

  @spec locale?(Locale.locale_code()) :: boolean()
  def locale?(locale_code) do
    Enum.member?(all_locale_codes(), locale_code)
  end

  @spec locale(Locale.locale_code()) :: Locale.locale() | {:error, String.t()}
  def locale(locale_code) do
    with {:ok, direction} <- locale_direction(locale_code),
         {:ok, name} <- locale_name(locale_code),
         {:ok, english_name} <- english_locale_name(locale_code) do
      %Locale{
        english_name: english_name,
        direction: direction,
        locale: locale_code,
        name: name
      }
    else
      error -> error
    end
  end

  @spec locale_direction(Locale.locale_code()) ::
          {:ok, CLDR.direction_type()} | {:error, :locale_not_found}
  def locale_direction(locale_code) do
    with language = language_from_locale_code(locale_code),
         {:ok, script} <- CLDR.likely_script(language, locale_code),
         direction <- CLDR.direction_from_script(script) do
      {:ok, direction}
    else
      error -> error
    end
  end

  @spec locale_name(Locale.locale_code()) :: {:ok, String.t()} | {:error, :locale_not_found}
  def locale_name(locale_code) do
    display_names =
      locale_code
      |> language_from_locale_code()
      |> CLDR.get_display_names()

    case display_names do
      {:error, :locale_not_found} = error -> error
      name_map -> {:ok, display_name(name_map, locale_code)}
    end
  end

  @spec capitalize(String.t()) :: String.t() | nil
  defp capitalize(nil), do: nil

  defp capitalize(string) do
    {first, rest} = String.split_at(string, 1)
    String.upcase(first) <> rest
  end

  @spec display_name(%{}, Locale.locale_code()) :: String.t() | :language_not_found
  defp display_name(display_names, locale_code) do
    language = language_from_locale_code(locale_code)

    case Map.Extra.fetch_first(display_names, [locale_code, language], :language_not_found) do
      {:error, :language_not_found} -> :language_not_found
      {:ok, name} -> capitalize(name)
    end
  end

  @spec language_from_locale_code(Locale.locale_code()) :: CLDR.language() | nil
  defp language_from_locale_code(locale_code) do
    locale_code
    |> String.split("-")
    |> Enum.at(0)
  end
end
