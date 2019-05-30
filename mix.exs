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
    # override applications so `kaffe`, `brod` and `erlzk` ar not started.
    # Its lifetime will be controlled by the application
    [extra_applications: [:logger], applications: []]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:kaffe, github: "IvanIvanoff/kaffe"},
      {:jason, "~> 1.1"}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end
end
