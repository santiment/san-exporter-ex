defmodule SanExporterEx.Application do
  @moduledoc false

  use Application

  # the producern name cannot be different
  @default_kafka_endpoint [localhost: 9092]
  @default_kafka_producer_name :kaffe_producer_client
  @default_kafka_topic "api_call_data"
  @default_kafka_flush_timeout 20000
  @default_buffering_max_messages 5000
  @default_kafka_compression_codec "lz4"
  @default_format_header "format=json"

  @type options :: [
          {:id, any()}
          | {:name, atom()}
          | {:topic, String.t()}
          | {:zookeeper_url, String.t()}
          | {:kafka_compression_codec, atom()}
          | {:kafka_url, String.t()}
          | {:kafka_flush_timeout, non_neg_integer()}
          | {:buffering_max_messages, non_neg_integer()}
          | {:format_header, String.t()}
        ]

  @spec child_spec(options) :: Supervisor.child_spec()
  def child_spec(opts) do
    id = Keyword.get(opts, :id, __MODULE__)

    %{
      id: id,
      start: {__MODULE__, :start, [:normal, opts]},
      type: :supervisor
    }
  end

  @spec start(atom, options) ::
          {:ok, pid} | {:error, {:already_started, pid} | {:shutdown, term} | term}
  def start(_type, opts) do
    defaults = [
      name: __MODULE__,
      kafka_endpoint: @default_kafka_endpoint,
      kafka_topic: @default_kafka_topic,
      kafka_flush_timeout: @default_kafka_flush_timeout,
      kafka_compression_codec: @default_kafka_compression_codec,
      buffering_max_messages: @default_buffering_max_messages,
      format_header: @default_format_header,
      kafka_producer_name: @default_kafka_producer_name
    ]

    opts = Keyword.merge(defaults, opts)

    kaffe_opts = [
      start_producer?: true,
      endpoints: opts[:kafka_endpoint],
      client_name: opts[:kafka_producer_name]
    ]

    # As applications is explicitly set to empty list, we need to manually start
    # brod, erlzk and kaffe when needed.
    # A task supervisor is needed to perform the async writes to kafka
    children = [
      {Task.Supervisor, [name: SanExporterEx.TaskSupervisor]},
      %{id: :erlzk, start: {:erlzk_app, :start, [:normal, []]}, type: :supervisor},
      %{id: :brod, start: {:brod_sup, :start_link, []}, type: :supervisor},
      %{id: :kafka_producer, start: {Kaffe, :start, [:normal, kaffe_opts]}, type: :supervisor}
    ]

    Supervisor.start_link(
      children,
      [strategy: :one_for_one] ++ Keyword.take(opts, [:name])
    )
  end
end
