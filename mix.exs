defmodule SanExporterEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :san_exporter_ex,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [extra_applications: [:logger], applications: [], included_applications: []]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:kaffe, github: "IvanIvanoff/kaffe"},
      {:distillery, "~> 2.0", runtime: false},
      {:jason, "~> 1.1"}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end
end
