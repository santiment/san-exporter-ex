defmodule SanExporterEx.Producer do
  @moduledoc ~s"""
  The standard Kakfa Producer provided by the library.

  This is a module implementing the SanExporterEx.ProducerBehaviour behaviour
  by using the libarry `Kaffe`. It supports sending data synchronously and
  sending data asynchronously by executing the job in a task under a supervisor.
  """

  @behaviour SanExporterEx.ProducerBehaviour

  @impl true
  def init(_), do: :ok

  @impl true
  def send_data(_, nil), do: :ok
  def send_data(_, []), do: :ok
  def send_data(topic, data), do: Kaffe.Producer.produce(topic, data)

  @impl true
  def send_data_async(topic, data, opts \\ []) do
    restart = Keyword.get(opts, :restart, :transient)

    Task.Supervisor.start_child(
      SanExporterEx.TaskSupervisor,
      __MODULE__,
      :send_data,
      [topic, data],
      restart: restart
    )
    |> case do
      {:ok, _} -> :ok
      error -> {:error, "Cannot send data. Reason: #{inspect(error)}"}
    end
  end
end
