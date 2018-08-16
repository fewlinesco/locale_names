defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  def run(args) do
    languages = CLDR.languages()

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

    formatters =
      if Enum.member?(args, "--json") do
        [Benchee.Formatters.JSON]
      else
        [Benchee.Formatters.Console]
      end

    formatter_options =
      case {Enum.member?(args, "--json"), Enum.member?(args, "--update-json")} do
        {true, true} -> [json: [file: "benchmark_baseline.json"]]
        {true, false} -> [json: [file: "benchmark.json"]]
        _ -> [console: %{comparison: false}]
      end

    Benchee.run(
      %{
        "locale?" => fn ->
          Enum.map(sample, fn locale -> Locale.locale?(locale) end)
        end,
        "locale" => fn ->
          Enum.map(sample, fn locale -> Locale.locale(locale) end)
        end
      },
      formatters: formatters,
      formatter_options: formatter_options
    )
  end
end
