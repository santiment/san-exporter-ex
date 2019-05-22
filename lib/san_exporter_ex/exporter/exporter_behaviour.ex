defmodule SanExporterEx.ExporterBehaviour do
  @type topic :: String.t()
  @type data :: any()

  @type result :: :ok | {:error, String.t()}

  @callback send_data(topic, data) :: result
  @callback send_data_async(topic, data) :: result
end
