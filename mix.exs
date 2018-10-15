defmodule LocaleNames.MixProject do
  use Mix.Project

  @project_url "https://github.com/fewlinesco/locale_names"

  def project do
    [
      app: :locale_names,
      deps: deps(),
      description: "Translation, spelling and direction of locales",
      dialyzer: dialyzer(),
      docs: [main: "readme", extras: ["README.md"]],
      elixir: "~> 1.6",
      homepage_url: @project_url,
      name: "Locale Names",
      package: package(),
      source_url: @project_url,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "1.0.0"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 0.11", only: [:dev, :test]},
      {:benchee_json, "~> 0.4", only: [:dev, :test]},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.14", only: :dev},
      {:excoveralls, "~> 0.7.1", only: :test},
      {:poison, "~> 3.1"}
    ]
  end

  defp dialyzer do
    [
      flags: [:error_handling, :no_opaque, :race_conditions, :unmatched_returns],
      plt_add_apps: [:mix],
      plt_add_deps: :app_tree
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "LICENSE*",
        "mix.exs",
        "priv/cldr-core/availableLocales.json",
        "priv/cldr-core/scriptMetadata.json",
        "priv/cldr-core/supplemental/languageData.json",
        "priv/cldr-core/supplemental/likelySubtags.json",
        "priv/cldr-localenames-full/main/**/languages.json",
        "priv/cldr-localenames-full/main/**/territories.json",
        "README*"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_url},
      maintainers: ["Vincent Billey", "Kevin Disneur"]
    ]
  end
end
