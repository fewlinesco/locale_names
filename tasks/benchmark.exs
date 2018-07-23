{:ok, languages} = CLDR.languages()

locales =
  Enum.reduce(languages, [], fn language, acc ->
    scripts = CLDR.script_for_language(language)

    languages_with_scripts =
      Enum.map(scripts, fn script ->
        language <> "-" <> script
      end)

    territories = CLDR.territories_for_language(language)

    languages_with_territories =
      Enum.map(territories, fn territory ->
        language <> "-" <> territory
      end)

    languages_with_scripts_and_territories =
      Enum.map(scripts, fn script ->
        Enum.map(territories, fn territory ->
          language <> "-" <> script <> "-" <> territory
        end)
      end)
      |> List.flatten()

    acc ++
      languages ++
      languages_with_scripts ++
      languages_with_territories ++ languages_with_scripts_and_territories
  end)

stream = Stream.cycle(locales)
sample = Enum.take(stream, 1000)

Benchee.run(%{
  "locale?" => fn ->
    Enum.map(sample, fn locale -> Locale.locale?(locale) end)
  end,
  "locale" => fn ->
    Enum.map(sample, fn locale -> Locale.locale(locale) end)
  end
})
