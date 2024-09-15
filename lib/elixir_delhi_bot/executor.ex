defmodule ElixirDelhiBot.Executor do
  def bot_command?(update) do
    case update do
      %{
        "update_id" => _new_update_id,
        "message" => %{
          "chat" => %{"id" => _chat_id},
          "entities" => [%{"type" => "bot_command"}],
          "text" => "/start"
        }
      } ->
        true

      _ ->
        false
    end
  end

  def handle_bot_command(update) do
    %{
      "update_id" => _new_update_id,
      "message" => %{
        "chat" => %{"id" => chat_id},
        "entities" => _entities,
        "text" => "/start"
      }
    } = update

    send_start_msg(chat_id)
  end

  defp send_start_msg(chat_id) do
    ElixirDelhiBot.Telegramex.send_message(
      chat_id,
      "Hello from Elixir Delhi Bot!"
    )
  end
end
