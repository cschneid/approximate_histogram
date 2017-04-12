defmodule ApproximateHistogram.Mixfile do
  use Mix.Project

  def project do
    [app: :approximate_histogram,
     version: "0.1.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Approximate Histograms",
     package: package(),
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
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp package do
    [
     name: :approximate_histogram,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Chris Schneider"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/cschneid/approximate_histogram",
              "Docs" => "https://github.com/cschneid/approximate_histogram"}]
  end
end
