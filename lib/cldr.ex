defmodule CLDR do
  alias Kaur.Result

  @script_path "priv/cldr-core/scriptMetadata.json"
  @likely_subtags_path "priv/cldr-core/supplemental/likelySubtags.json"
  @localenames_path "priv/cldr-localenames-full"

  def direction_from_script(script) do
    @script_path
    |> File.read()
    |> Result.map_error(fn
      :enoent -> :locale_does_not_exist
      error -> error
    end)
    |> Result.map(&Poison.decode!/1)
    |> Result.map(&get_in(&1, ["scriptMetadata", script, "rtl"]))
    |> Result.keep_if(fn script -> script != nil end, :script_does_not_exist)
    |> Result.map(&direction/1)
  end

  def get_display_names(language) do
    language
    |> full_localenames_path()
    |> File.read()
    |> Result.map_error(fn
      :enoent -> :locale_does_not_exist
      error -> error
    end)
    |> Result.map(&Poison.decode!/1)
    |> Result.map(&get_in(&1, ["main", language, "localeDisplayNames", "languages"]))
  end

  def likely_script(language, locale \\ "") do
    @likely_subtags_path
    |> File.read()
    |> Result.map(&Poison.decode!/1)
    |> Result.map(&get_in(&1, ["supplemental", "likelySubtags"]))
    |> Result.and_then(&fetch_likely_script(&1, language, locale))
    |> Result.map(&String.split(&1, "-"))
    |> Result.map(&Enum.at(&1, 1))
  end

  defp fetch_likely_script(subtags, language, locale) do
    Result.Map.fetch_with_fallback(subtags, [locale, language], :locale_does_not_exist)
  end

  defp direction(rtl) do
    case rtl do
      "YES" -> :right_to_left
      "NO" -> :left_to_right
      _ -> :unknown_direction
    end
  end

  defp full_localenames_path(language) do
    @localenames_path <> "/main/#{language}/languages.json"
  end
end