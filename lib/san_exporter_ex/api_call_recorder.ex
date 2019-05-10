defmodule SanExrpoterEx.ApiCallRecorder do
  use GenServer

  @type api_call_data :: %{
          timestamp: non_neg_integer(),
          user_id: non_neg_integer(),
          remote_ip: String.t(),
          san_tokens: float(),
          query: String.t()
        }

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    Process.send_after(self(), :flush, 5000)
    {:ok, %{topic: opts[:topic], data: []}}
  end

  @spec persist(api_call_data) :: :ok
  def persist(api_call_data) do
    GenServer.cast(__MODULE__, {:persist, api_call_data})
  end

  def handle_cast(
        {:persist, api_call_data},
        %{topic: topic, data: data, size: size, buffering_max_messages: buffering_max_messages} =
          state
      )
      when size >= buffering_max_messages - 1 do
    :ok = SanExporterEx.Exporter.send_data(topic, [api_call_data |> Jason.encode!() | data])

    {:noreply, %{state | data: [], size: 0}}
  end

  def handle_cast(
        {:persist, api_call_data},
        %{data: data, size: size} = state
      ) do
    {:noreply, %{state | data: [api_call_data |> Jason.encode!() | data], size: size + 1}}
  end

  def handle_info(:flush, %{topic: topic, data: data}) do
    :ok = SanExporterEx.Exporter.send_data(topic, data)
    Process.send_after(self(), :flush, 5000)
    {:noreply, %{topic: topic, data: [], size: 0}}
  end
end
