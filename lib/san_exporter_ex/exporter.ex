defmodule SanExporterEx.Exporter do
  def send_data(topic, data) do
    Kaffe.Producer.produce(topic, data)
  end

  def send_data_async(topic, data) do
  end
end
