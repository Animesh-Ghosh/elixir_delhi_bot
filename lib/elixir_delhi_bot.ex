defmodule ElixirDelhiBot do
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

  defp first_unprocessed_update(updates, nil), do: List.last(updates)

  defp first_unprocessed_update(updates, last_update_id) do
    first_unprocessed_update =
      Enum.find(updates, fn update -> update["update_id"] > last_update_id end)

    case first_unprocessed_update do
      nil -> {:error, :no_unprocessed_update}
      update -> {:ok, update}
    end
  end

  def process_update(%{} = update) do
    case update do
      %{
        "message" => %{
          "chat" => %{"id" => chat_id},
          "new_chat_members" => new_chat_members
        }
      } ->
        greet_new_members(chat_id, new_chat_members)

      _ ->
        {:error, :unhandled_update}
    end
  end

  def greet_new_members(last_update_id) do
    # TODO: too many helper methods, move into a separate module
    with {:ok, updates} <- get_updates(),
         {:ok, chat_id, new_chat_members, update_id} <-
           new_chat_members_from(updates, last_update_id) do
      greet_new_members(chat_id, new_chat_members)
      {:ok, update_id}
    else
      {:error, :no_matching_update, non_matching_update} ->
        {:ok, last_update_id}
    end
  end

  defp get_updates do
    {:ok, %{"result" => result}} = ElixirDelhiBot.Telegramex.get_updates()
    {:ok, result}
  end

  defp new_chat_members_from(updates, last_update_id) do
    case last_update_of(updates) do
      {:ok, chat_id, new_chat_members, update_id} ->
        new_chat_members =
          if new_update?(last_update_id, update_id) do
            new_chat_members
          else
            []
          end

        {:ok, chat_id, new_chat_members, update_id}

      error ->
        error
    end
  end

  defp last_update_of(updates) do
    case List.last(updates) do
      %{
        "message" => %{
          "chat" => %{
            "id" => chat_id
          },
          "new_chat_members" => new_chat_members
        },
        "update_id" => update_id
      } ->
        {:ok, chat_id, new_chat_members, update_id}

      non_matching_update ->
        {:error, :no_matching_update, non_matching_update}
    end
  end

  defp new_update?(last_update_id, current_update_id) do
    if is_nil(last_update_id) do
      true
    else
      current_update_id > last_update_id
    end
  end

  defp greet_new_members(_chat_id, new_chat_members) when length(new_chat_members) == 0, do: :noop

  defp greet_new_members(chat_id, new_chat_members) do
    non_bot_members(new_chat_members)
    |> Enum.each(fn new_chat_member ->
      greet_new_member(chat_id, new_chat_member)
    end)
  end

  def greet_new_member(chat_id, new_chat_member) do
    ElixirDelhiBot.Telegramex.send_message(
      chat_id,
      "A wild #{new_chat_member["first_name"]} appeared!"
    )
  end

  defp non_bot_members(new_chat_members) do
    Enum.filter(new_chat_members, fn new_chat_member ->
      !new_chat_member["is_bot"]
    end)
  end
end
