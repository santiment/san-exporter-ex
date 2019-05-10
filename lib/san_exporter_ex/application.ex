defmodule SanExporterEx.Application do
  @moduledoc false

  use Application

  @default_zookeeper_url "localhost:2181"
  @default_kafka_url "localhost:9092"
  @default_kafka_topic "api_call_data"
  @default_kafka_flush_timeout "5000"
  @default_kafka_compression_codec "lz4"
  @default_buffering_max_messages "20000"
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
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end

  @spec start_link(options) ::
          {:ok, pid} | {:error, {:already_started, pid} | {:shutdown, term} | term}
  def start_link(opts) do
    defaults = [
      name: __MODULE__,
      zookeeper_url: @default_zookeeper_url,
      kafka_url: @default_kafka_url,
      kafka_topic: @default_kafka_topic,
      kafka_flush_timeout: @default_kafka_flush_timeout,
      kafka_compression_codec: @default_kafka_compression_codec,
      buffering_max_messages: @default_buffering_max_messages,
      format_header: @default_format_header
    ]

    opts = Keyword.merge(defaults, opts)

    children = [
      {Task.Supervisor, [name: Sanbase.TaskSupervisor]}
    ]

    :erlzk.start()

    Supervisor.start_link(
      children,
      [strategy: :one_for_one] ++ Keyword.take(opts, [:name])
    )
  end
end
