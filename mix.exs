defmodule PhoenixSlime.Mixfile do
  use Mix.Project

  @version "0.13.1"

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
      {:phoenix, "~> 1.6.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17.2"},
      {:jason, "~> 1.0", optional: true},
      # {:slime, "~> 1.0"},
      {:slime, path: "../slime_heex"},
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
