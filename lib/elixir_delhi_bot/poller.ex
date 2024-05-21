defmodule ElixirDelhiBot.Poller do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    last_update_id = CubDB.get(:my_cubdb, :last_update_id)
    schedule_poll()

    {:ok, last_update_id}
  end

  @impl true
  def handle_info(:poll, last_update_id) do
    updates = poll_updates()
    {:ok, new_update_id} = ElixirDelhiBot.process_updates(updates, last_update_id)
    schedule_poll()
    CubDB.put(:my_cubdb, :last_update_id, new_update_id)

    {:noreply, new_update_id}
  end

  defp schedule_poll do
    Process.send_after(self(), :poll, :timer.seconds(12))
  end

  defp poll_updates do
    case ElixirDelhiBot.Telegramex.get_updates() do
      {:ok, %{"result" => updates}} ->
        updates

      {:error, reason} ->
        IO.inspect(reason)
        []
    end
  end
end
