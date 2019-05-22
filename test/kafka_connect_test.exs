defmodule KafkaConnectTest do
  use ExUnit.Case

  @moduletag requires_kafka: true

  test "connects to kafka" do
    {:ok, pid} = SanExporterEx.Application.start(:normal, [])
    assert is_pid(pid)
  end
end
