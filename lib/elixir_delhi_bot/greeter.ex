defmodule ElixirDelhiBot.Greeter do
  @greeting_templates [
    ~s(A wild ~ts appeared!),
    ~s(~ts just joined the server!),
    ~s(~ts just joined. Everyone, look busy!),
    ~s(Welcome ~ts. We hope you brought pizza.),
    ~s("~ts" |> welcome() |> to_the_group()),
    ~s(Pattern matched: %{new_member: "~ts"}),
    ~s(spawn(fn -> greet("~ts") end)),
    ~s("~ts" has been added to the process registry!),
    ~s(GenServer started for "~ts"!)
  ]

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
    first_name
    |> build_greeting()
    |> then(&ElixirDelhiBot.Telegramex.send_message(chat_id, &1))
  end

  defp build_greeting(name) do
    Enum.random(@greeting_templates)
    |> :io_lib.format([name])
    |> to_string()
  end
end
