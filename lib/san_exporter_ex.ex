defmodule SanExporterEx do
  @moduledoc ~s"""
  ### Summary

  SanExporterEx is an Elixir library for pushing data to Santiment pipelines.

  The library has two main goals - comunicate with Zookeeper and comunicate with Kafka.
  Zookeeper is used for storing some metadata such as last scraped position. This
  will allow scrapers to store data that will persist restarts and crashes.
  Kafka is used as a warehouse where the actual data is pushed.

  The library is used as a Kafka Producer. If you need a consumer you need to
  look at other libraries.

  At the core of SanExporterEx is Kaffe, which is an elixir wrapper around brod
  (pure Erlang Kafka client).

  ### Configuration


  """
end
