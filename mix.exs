defmodule SanExporterEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :san_exporter_ex,
      version: "0.1.0",
      elixir: "~> 1.9-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    # override applications so `erlzk` is not started. It's lifetime will be
    # controlled by the application
    [extra_applications: [:logger], applications: []]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kaffe, "~> 1.9"},
      {:erlzk, "~> 0.6.2"},
      {:jason, "~> 1.1"}
    ]
  end
end
