defmodule ElixirDelhiBot.Greeter do
  def new_chat_members_joined?(%{} = update) do
    case update do
      %{
        "message" => %{
          "chat" => %{"id" => _chat_id},
          "new_chat_members" => _new_chat_members
        }
      } ->
        true

      _ ->
        false
    end
  end

  def handle_new_chat_members(%{} = update) do
    %{
      "message" => %{
        "chat" => %{"id" => chat_id},
        "new_chat_members" => new_chat_members
      }
    } = update

    greet_new_members(chat_id, new_chat_members)
  end

  defp greet_new_members(_chat_id, new_chat_members) when length(new_chat_members) == 0, do: :noop

  defp greet_new_members(chat_id, new_chat_members) do
    non_bot_members(new_chat_members)
    |> Enum.each(fn new_chat_member ->
      greet_new_member(chat_id, new_chat_member)
    end)
  end

  defp greet_new_member(chat_id, new_chat_member) do
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
