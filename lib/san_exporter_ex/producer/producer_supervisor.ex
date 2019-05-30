defmodule SanExporterEx.Producer.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  @impl Supervisor
  def init(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    brod_sup_id = "brod_sup_#{name}"
    kaffe_producer_id = "kaffe_producer_#{name}"

    kaffe_opts = [
      start_producer?: true,
      endpoints: opts[:kafka_endpoint],
      client_name: opts[:kafka_producer_name]
    ]

    children = [
      %{id: brod_sup_id, start: {:brod_sup, :start_link, []}, type: :supervisor},
      %{id: kaffe_producer_id, start: {Kaffe, :start, [:normal, kaffe_opts]}, type: :supervisor}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
