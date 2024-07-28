defmodule ElixirDelhiBot do
  alias ElixirDelhiBot.Greeter

  @doc """
  Processes a list of Updates.
  """
  def process_updates([], last_update_id), do: {:ok, last_update_id}

  def process_updates(updates, last_update_id) do
    case first_unprocessed_update(updates, last_update_id) do
      {:error, :no_unprocessed_update} ->
        {:ok, last_update_id}

      {:ok, update} ->
        process_update(update)
        {:ok, update["update_id"]}
    end
  end

  defp first_unprocessed_update(updates, nil), do: {:ok, List.last(updates)}

  defp first_unprocessed_update(updates, last_update_id) do
    first_unprocessed_update =
      Enum.find(updates, fn update -> update["update_id"] > last_update_id end)

    case first_unprocessed_update do
      nil -> {:error, :no_unprocessed_update}
      update -> {:ok, update}
    end
  end

  @doc """
  Processes a single Update.
  """
  def process_update(%{} = update) do
    cond do
      # add support for new features
      # like commands etc
      Greeter.new_chat_members_joined?(update) ->
        Greeter.handle_new_chat_members(update)

      true ->
        {:error, :unhandled_update}
    end
  end
end
