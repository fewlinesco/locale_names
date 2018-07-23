defmodule CLDR do
  alias Kaur.Result

  @available_locales_path "priv/cldr-core/availableLocales.json"
  @language_data_path "priv/cldr-core/supplemental/languageData.json"
  @script_path "priv/cldr-core/scriptMetadata.json"
  @likely_subtags_path "priv/cldr-core/supplemental/likelySubtags.json"
  @localenames_path "priv/cldr-localenames-full"

  def available_locales do
    @available_locales_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["availableLocales", "modern"])
  end

  def direction_from_script(script) do
    @script_path
    |> File.read()
    |> Result.map_error(fn
      :enoent -> :locale_not_found
      error -> error
    end)
    |> Result.and_then(&Poison.decode/1)
    |> Result.map(&get_in(&1, ["scriptMetadata", script, "rtl"]))
    |> Result.keep_if(fn script -> script != nil end, :script_not_found)
    |> Result.map(&direction/1)
  end

  def get_display_names(language) do
    language
    |> full_localenames_path()
    |> File.read()
    |> Result.map_error(fn
      :enoent -> :locale_not_found
      error -> error
    end)
    |> Result.and_then(&Poison.decode/1)
    |> Result.map(&get_in(&1, ["main", language, "localeDisplayNames", "languages"]))
  end

  def likely_script(language, locale \\ "") do
    @likely_subtags_path
    |> File.read()
    |> Result.and_then(&Poison.decode/1)
    |> Result.map(&get_in(&1, ["supplemental", "likelySubtags"]))
    |> Result.and_then(&fetch_likely_script(&1, language, locale))
    |> Result.map(&String.split(&1, "-"))
    |> Result.map(&Enum.at(&1, 1))
    |> Result.keep_if(fn script -> script != nil end, :script_not_found)
  end

  def languages do
    @language_data_path
    |> File.read()
    |> Result.and_then(&Poison.decode/1)
    |> Result.map(&get_in(&1, ["supplemental", "languageData"]))
    |> Result.map(&Map.keys/1)
    |> Result.map(
      &Enum.reject(&1, fn language -> String.ends_with?(language, "-alt-secondary") end)
    )
  end

  def scripts do
    @script_path
    |> File.read()
    |> Result.and_then(&Poison.decode/1)
    |> Result.map(&get_in(&1, ["scriptMetadata"]))
    |> Result.map(&Map.keys/1)
  end

  def script_for_language(language) do
    @language_data_path
    |> File.read()
    |> Result.and_then(&Poison.decode/1)
    |> Result.map(&get_in(&1, ["supplemental", "languageData", language, "_scripts"]))
    |> Result.keep_if(fn scripts -> scripts != nil end)
    |> Result.with_default([])
  end

  def territories_for_language(language) do
    @language_data_path
    |> File.read()
    |> Result.and_then(&Poison.decode/1)
    |> Result.map(&get_in(&1, ["supplemental", "languageData", language, "_territories"]))
    |> Result.keep_if(fn territories -> territories != nil end)
    |> Result.with_default([])
  end

  def territories do
    "en"
    |> full_localenames_territories_path()
    |> File.read()
    |> Result.and_then(&Poison.decode/1)
    |> Result.map(&get_in(&1, ["main", "en", "localeDisplayNames", "territories"]))
    |> Result.map(&Map.keys/1)
  end

  defp fetch_likely_script(subtags, language, locale) do
    Result.Map.fetch_first(subtags, [locale, language], :locale_not_found)
  end

  defp direction("YES"), do: :right_to_left
  defp direction("NO"), do: :left_to_right
  defp direction(_), do: :unknown_direction

  defp full_localenames_path(language) do
    @localenames_path <> "/main/#{language}/languages.json"
  end

  defp full_localenames_territories_path(language) do
    @localenames_path <> "/main/#{language}/territories.json"
  end
end
