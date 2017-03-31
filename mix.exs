defmodule ApproximateHistogram.Mixfile do
  use Mix.Project

  def project do
    [app: :approximate_histogram,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:benchfella, "~> 0.3", only: :dev},
      {:credo,      "~> 0.4", only: [:dev, :test]},
      {:dialyxir,   "~> 0.4", only: [:dev], runtime: false},
      {:propcheck,  "~> 0.0", only: [:dev, :test]},
      {:dogma,      "~> 0.1", only: :dev},
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
     name: :approximate_histogram,
     files: ["lib", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     maintainers: ["Chris Schneider"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/cschneid/approximate_histogram",
              "Docs" => "https://github.com/cschneid/approximate_histogram"}]
  end
end
