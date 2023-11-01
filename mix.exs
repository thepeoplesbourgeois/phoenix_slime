defmodule PhoenixSlime.Mixfile do
  use Mix.Project

  @version "0.13.0"

  def project do
    [
      app: :phoenix_slime,
      deps: deps(),
      description: "Phoenix Template Engine for Slim-like templates",
      elixir: "~> 1.4",
      package: package(),
      version: @version
    ]
  end

  def application do
    [applications: [:phoenix, :slime]]
  end

  def deps do
    [
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17"},
      {:jason, "~> 1.0", optional: true},
      {:slime, github: "tensiondriven/slime", branch: "master"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Sean Callan", "Alexander Stanko"],
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/slime-lang/phoenix_slime"}
    ]
  end
end
