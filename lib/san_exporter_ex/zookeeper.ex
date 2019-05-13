defmodule SanExporterEx.Zookeeper do
  def connect(host, port, timeout \\ 30_000) do
    :erlzk.connect([{host, port}], timeout)
  end

  def close(pid) when is_pid(pid) do
    :erlzk.close(pid)
  end

  def get_last_position(pid, identifier) do
    :erlzk.get_data(pid, identifier)
  end

  def save_last_position(pid, identifier, position) do
    :erlzk.set_data(pid, identifier, position)
  end
end
