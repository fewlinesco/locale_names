defmodule CLDR do
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
    |> Enum.reject(fn locale -> locale == "root" end)
  end

  def direction_from_script(script) do
    @script_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["scriptMetadata", script, "rtl"])
    |> direction()
  end

  def get_display_names(language) do
    with path <- full_localenames_path(language),
         {:ok, binary} <- File.read(path),
         {:ok, json} <- Poison.decode(binary) do
      get_in(json, ["main", language, "localeDisplayNames", "languages"])
    else
      _ ->
        {:error, :locale_not_found}
    end
  end

  def likely_script(language, locale \\ "") do
    subtag =
      @likely_subtags_path
      |> File.read!()
      |> Poison.decode!()
      |> get_in(["supplemental", "likelySubtags"])

    case fetch_likely_script(subtag, language, locale) do
      {:ok, locale} ->
        script =
          locale
          |> String.split("-")
          |> Enum.fetch!(1)

        {:ok, script}

      error ->
        error
    end
  end

  def languages do
    available_locales()
    |> Enum.map(fn locale ->
      locale
      |> String.split("-")
      |> Enum.at(0)
    end)
    |> Enum.uniq()
  end

  def scripts do
    @script_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["scriptMetadata"])
    |> Map.keys()
  end

  def script_for_language(language) do
    @language_data_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["supplemental", "languageData", language, "_scripts"])
    |> List.wrap()
  end

  def territories_for_language(language) do
    @language_data_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["supplemental", "languageData", language, "_territories"])
    |> List.wrap()
  end

  def territories do
    "en"
    |> full_localenames_territories_path()
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["main", "en", "localeDisplayNames", "territories"])
    |> Map.keys()
  end

  defp fetch_likely_script(subtags, language, locale) do
    Map.Extra.fetch_first(subtags, [locale, language], :locale_not_found)
  end

  defp direction("YES"), do: :right_to_left
  defp direction("NO"), do: :left_to_right
  defp direction(_), do: :unknown_direction

  defp full_localenames_path(language) do
    Path.join([@localenames_path, "main", language, "languages.json"])
  end

  defp full_localenames_territories_path(language) do
    Path.join([@localenames_path, "main", language, "territories.json"])
  end
end
