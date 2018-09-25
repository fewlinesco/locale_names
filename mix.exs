defmodule LocaleNames.MixProject do
  use Mix.Project

  def project do
    [
      app: :locale_names,
      version: "1.0.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer()
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
      {:poison, "~> 3.1"}
    ]
  end

  defp dialyzer do
    [
      flags: [:error_handling, :no_opaque, :race_conditions, :underspecs, :unmatched_returns],
      plt_add_apps: [:mix],
      plt_add_deps: :app_tree
    ]
  end
end
