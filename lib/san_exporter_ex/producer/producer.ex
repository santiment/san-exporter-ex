defmodule SanExporterEx.Producer do
  @behaviour SanExporterEx.ProducerBehaviour

  @impl true
  def init(_), do: :ok
  @impl true
  def send_data(_, data) when is_nil(data) or data == [], do: :ok

  @impl true
  def send_data(topic, data) do
    Kaffe.Producer.produce(topic, data)
  end

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