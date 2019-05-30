defmodule SanExporterEx.Supervisor do
  @moduledoc false

  use Supervisor

  # the producer name cannot be different
  @default_kafka_endpoint [kafka: 9092]
  @default_kafka_producer_name :kaffe_producer_client
  @default_kafka_topic "api_call_data"
  @default_kafka_flush_timeout 20000
  @default_buffering_max_messages 5000
  @default_kafka_compression_codec "lz4"
  @default_format_header "format=json"

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  @impl Supervisor
  def init(opts) do
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

    producer = Keyword.get(opts, :kafka_producer_module, SanExporterEx.Producer.Supervisor)

    # As applications is explicitly set to empty list, we need to manually start
    # brod, and kaffe if needed.
    # A task supervisor is needed to perform the async writes to kafka
    children = [
      {Task.Supervisor, [name: SanExporterEx.TaskSupervisor]},
      {producer, opts}
    ]

    Supervisor.init(
      children,
      strategy: :one_for_one
    )
  end
end
