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
      {:kaffe, github: "IvanIvanoff/kaffe"},
      {:erlzk, "~> 0.6.2"},
      {:jason, "~> 1.1"},
      {:distillery, "~> 2.0", runtime: false}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end
end
