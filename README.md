# SanExporterEx

`SanExporterEx.Producer.Supervisor` accepts an option `:start_brod_supervisor`
which is `true` by default. If `false` is provided, `:brod_sup` won't be started.
This is to be used when other parts of the application that this SanExporterEx is
used in can decide when and how to start the brod supervisor. One notable case is
dev/test environments when the producer is replaced by an in-memory one but the other
parts of the application still need the brod supervisor.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `san_exporter_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:san_exporter_ex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/san_exporter_ex](https://hexdocs.pm/san_exporter_ex).

