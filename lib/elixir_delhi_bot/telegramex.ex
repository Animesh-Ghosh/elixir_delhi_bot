defmodule ElixirDelhiBot.Telegramex do
  def send_message(chat_id, text) do
    client()
    |> Telegramex.API.call("sendMessage", %{chat_id: chat_id, text: text})
  end

  def get_updates do
    client()
    |> Telegramex.get_updates(allowed_updates: [:message])
  end

  defp client do
    %Telegramex.Client{token: token()}
  end

  defp token do
    Application.fetch_env!(:elixir_delhi_bot, :bot_token)
  end
end
