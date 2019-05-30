defmodule SanExporterEx do
  @moduledoc ~s"""
   ### Summary

  SanExporterEx is an Elixir library for pushing data to kafka topics.

  The library has two main goals - communicate with Zookeeper (#TODO) and
  comunicate with Kafka.

  Zookeeper is used for storing some metadata such as last scraped position. This
  will allow scrapers to store data that will persist restarts and crashes.
  Kafka is used as a warehouse where the actual data is pushed.

  The library is used as a Kafka Producer. If you need a consumer you need to
  look at other libraries.

  At the core of SanExporterEx is Kaffe, which is an elixir wrapper around brod
  (pure Erlang Kafka client).

  ### Configuration

  When starting SanExporterEx you can provide the following options in a keyword list:

  - id: Uniquely identify SanExporterEx in the supervisor tree
  - name: Passed to the module that will start the producer. Also uniquely identifies the producer in the supervision tree
  - kafka_topic: The Kafka topic name to which data is exported. The default producer does not
    use it.
  - kafka_compression_codec: The kafka compression codec. Supported are: :gzip, :snappy, :lz4 (#TODO)
  - kafka_url: A Keyword list of kafka endpoints. Example: [kafka: 9092]
  - kafka_flush_timeout: How often the batched messages are going to be sent
  - buffering_max_messages: How many messages can be buffered at a time. If this number is reached the buffer is sent to kafka.
  - kafka_producer_name: Passed to Kaffe as :client_name. If Kaffe is used, the producer name cannot be different than that.


  ### Usage

  The minimal setup to start using it is to just start the Supervisor and call `send_data`:
    > SanExporterEx.Supervisor.start_link([])
    > SanExporterEx.Producer.send_data("random_topic", [{"key", "{1,2,3,4}"}])

  Or start it under your supervisor tree:
  children = [
    ...
    SanExporterEx,
    ...
  ]
  """

  @type options :: [
          {:id, any()}
          | {:name, atom()}
          | {:kafka_topic, String.t()}
          | {:kafka_compression_codec, atom()}
          | {:kafka_endpoint, [{atom, non_neg_integer()}]}
          | {:kafka_flush_timeout, non_neg_integer()}
          | {:buffering_max_messages, non_neg_integer()}
          | {:format_header, String.t()}
          | {:kafka_producer_name, any()}
        ]

  @spec child_spec(options) :: Supervisor.child_spec()
  def child_spec(opts) do
    id = Keyword.get(opts, :id, __MODULE__)

    %{
      id: id,
      start: {__MODULE__.Supervisor, :start_link, [opts]},
      type: :supervisor
    }
  end
end
