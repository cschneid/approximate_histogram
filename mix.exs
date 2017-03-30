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

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
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
end
