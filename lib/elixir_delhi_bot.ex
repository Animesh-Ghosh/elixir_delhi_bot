defmodule ElixirDelhiBot do
  def greet_new_members(last_update_id) do
    # TODO: too many helper methods, move into a separate module
    with {:ok, updates} <- get_updates(),
         {:ok, chat_id, new_chat_members, update_id} <-
           new_chat_members_from(updates, last_update_id) do
      greet_new_members(chat_id, new_chat_members)
      {:ok, update_id}
    end
  end

  defp get_updates do
    {:ok, %{"result" => result}} = ElixirDelhiBot.Telegramex.get_updates()
    {:ok, result}
  end

  defp new_chat_members_from(updates, last_update_id) do
    {:ok, chat_id, new_chat_members, update_id} = last_update_of(updates)

    new_chat_members =
      if new_update?(last_update_id, update_id) do
        new_chat_members
      else
        []
      end

    {:ok, chat_id, new_chat_members, update_id}
  end

  defp last_update_of(updates) do
    %{
      "message" => %{
        "chat" => %{
          "id" => chat_id
        },
        "new_chat_members" => new_chat_members
      },
      "update_id" => update_id
    } = List.last(updates)

    {:ok, chat_id, new_chat_members, update_id}
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
