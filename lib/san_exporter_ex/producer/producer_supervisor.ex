defmodule SanExporterEx.Producer.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  @impl Supervisor
  def init(opts) do
    start_brod_supervisor = Keyword.get(opts, :start_brod_supervisor, true)
    name = Keyword.get(opts, :name, __MODULE__)

    kaffe_producer_id = "kaffe_producer_#{name}"

    kaffe_opts = [
      start_producer?: true,
      endpoints: opts[:kafka_endpoint],
      client_name: opts[:kafka_producer_name]
    ]

    children = [
      %{id: kaffe_producer_id, start: {Kaffe, :start, [:normal, kaffe_opts]}, type: :supervisor}
    ]

    children =
      case start_brod_supervisor do
        true ->
          [%{id: :"brod_sup_#{name}", start: {:brod_sup, :start_link, []}, type: :supervisor}] ++ children

        false ->
          children
      end

    Supervisor.init(children, strategy: :one_for_all)
  end
end
