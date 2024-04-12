defmodule ElixirDelhiBot.Worker do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(state) do
    schedule_worker()

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    {:ok, new_update_id} = ElixirDelhiBot.greet_new_members(state)
    reschedule_worker()

    {:noreply, new_update_id}
  end

  defp reschedule_worker do
    schedule_worker()
  end

  defp schedule_worker do
    Process.send_after(self(), :work, :timer.seconds(15))
  end
end
