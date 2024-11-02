defmodule ElixirDelhiBot.Executor do
  @bot_commands ~w[/start /help]

  def bot_command?(update) do
    case update do
      %{
        "update_id" => _new_update_id,
        "message" => %{
          "chat" => %{"id" => _chat_id},
          "entities" => [%{"type" => "bot_command"}],
          "text" => bot_command
        }
      } ->
        bot_command in @bot_commands

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
        "text" => bot_command
      }
    } = update

    case bot_command do
      "/start" -> handle_start_command(chat_id)
      "/help" -> handle_help_command(chat_id)
    end
  end

  defp handle_start_command(chat_id) do
    ElixirDelhiBot.Telegramex.send_message(
      chat_id,
      "Hello from Elixir Delhi Bot!"
    )
  end

  defp handle_help_command(chat_id) do
    help_message = """
    I am a simple bot that can help you with the following commands:

    /start - send an intro message
    /help - display this help message
    """

    ElixirDelhiBot.Telegramex.send_message(chat_id, help_message)
  end
end
