defmodule ElixirDelhiBot.BotCommandHandler do
  def command?(update) do
    case update do
      %{
        "update_id" => _new_update_id,
        "message" => %{
          "chat" => %{"id" => _chat_id},
          "entities" => [%{"type" => "bot_command"}],
          "text" => "/start"
        }
      } -> true
      _ -> false
    end
  end

  def handle_command(updater) do
    %{
      "update_id" => _new_update_id,
      "message" => %{
        "chat" => %{"id" => chat_id},
        "entities" => _entities,
        "text" => "/start"
      }
    } = updater

    send_start_msg(chat_id)
  end

  defp send_start_msg(chat_id) do
    ElixirDelhiBot.Telegramex.send_message(
      chat_id,
      "Hello from Elixir BLR!"
    )
    :noop
  end
end
