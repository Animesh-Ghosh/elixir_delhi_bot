defmodule ElixirDelhiBot.Worker do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    state = CubDB.get(:my_cubdb, :last_update_id)
    schedule_worker()

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    {:ok, new_update_id} = ElixirDelhiBot.greet_new_members(state)
    schedule_worker()
    CubDB.put(:my_cubdb, :last_update_id, new_update_id)

    {:noreply, new_update_id}
  end

  defp schedule_worker do
    Process.send_after(self(), :work, :timer.seconds(15))
  end
end
