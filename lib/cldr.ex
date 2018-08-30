defmodule CLDR do
  @available_locales_path "priv/cldr-core/availableLocales.json"
  @language_data_path "priv/cldr-core/supplemental/languageData.json"
  @script_path "priv/cldr-core/scriptMetadata.json"
  @likely_subtags_path "priv/cldr-core/supplemental/likelySubtags.json"
  @localenames_path "priv/cldr-localenames-full"

  @type direction_type() :: :left_to_right | :right_to_left | :unknown_direction
  @type language() :: String.t()
  @type script() :: String.t()

  @spec available_locales() :: list(Locale.locale_code())
  def available_locales do
    @available_locales_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["availableLocales", "modern"])
    |> Enum.reject(fn locale -> locale == "root" end)
  end

  @spec direction_from_script(script()) :: direction_type()
  def direction_from_script(script) do
    @script_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["scriptMetadata", script, "rtl"])
    |> direction()
  end

  @spec get_display_names(language()) ::
          %{required(language()) => String.t()} | {:error, :locale_not_found}
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

  @spec likely_script(language(), Locale.locale_code()) :: {:ok, script()} | {:error, String.t()}
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

  @spec languages() :: list(language())
  def languages do
    available_locales()
    |> Enum.map(fn locale ->
      locale
      |> String.split("-")
      |> Enum.at(0)
    end)
    |> Enum.uniq()
  end

  @spec scripts() :: list(script())
  def scripts do
    @script_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["scriptMetadata"])
    |> Map.keys()
  end

  @spec script_for_language(language()) :: list(script())
  def script_for_language(language) do
    @language_data_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["supplemental", "languageData", language, "_scripts"])
    |> List.wrap()
  end

  @spec territories_for_language(language()) :: list(String.t())
  def territories_for_language(language) do
    @language_data_path
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["supplemental", "languageData", language, "_territories"])
    |> List.wrap()
  end

  @spec territories() :: list(String.t())
  def territories do
    "en"
    |> full_localenames_territories_path()
    |> File.read!()
    |> Poison.decode!()
    |> get_in(["main", "en", "localeDisplayNames", "territories"])
    |> Map.keys()
  end

  @spec fetch_likely_script(map(), language(), Locale.locale_code()) ::
          {:ok, script()} | {:error, :locale_not_found}
  defp fetch_likely_script(subtags, language, locale) do
    Map.Extra.fetch_first(subtags, [locale, language], :locale_not_found)
  end

  @spec direction(String.t()) :: direction_type()
  defp direction("YES"), do: :right_to_left
  defp direction("NO"), do: :left_to_right
  defp direction(_), do: :unknown_direction

  @spec full_localenames_path(language()) :: String.t()
  defp full_localenames_path(language) do
    Path.join([@localenames_path, "main", language, "languages.json"])
  end

  @spec full_localenames_territories_path(language()) :: String.t()
  defp full_localenames_territories_path(language) do
    Path.join([@localenames_path, "main", language, "territories.json"])
  end
end
