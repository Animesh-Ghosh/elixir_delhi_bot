defmodule ElixirDelhiBot.Greeter do
  @doc """
  Checks if the Update was a new_chat_members Update.
  """
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

  @doc """
  Handles the new_chat_members Update.
  """
  def handle_new_chat_members(%{} = update) do
    %{
      "message" => %{
        "chat" => %{"id" => chat_id},
        "new_chat_members" => new_chat_members
      }
    } = update

    greet_new_members(chat_id, new_chat_members)
  end

  defp greet_new_members(_chat_id, []), do: :noop

  defp greet_new_members(chat_id, [first | rest]) do
    greet_new_member(chat_id, first)
    greet_new_members(chat_id, rest)
  end

  defp greet_new_member(_chat_id, %{"is_bot" => true}), do: :noop

  defp greet_new_member(chat_id, %{"first_name" => first_name}) do
    ElixirDelhiBot.Telegramex.send_message(
      chat_id,
      "A wild #{first_name} appeared!"
    )
  end
end
