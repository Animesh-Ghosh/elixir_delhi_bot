defmodule ElixirDelhiBot.Telegramex do
  @callback send_message(non_neg_integer(), String.t()) :: term()
  @callback get_updates() :: {:ok, map()} | {:error, term()}

  def send_message(chat_id, text) do
    impl().send_message(chat_id, text)
  end

  def get_updates do
    impl().get_updates()
  end

  defp impl do
    Application.get_env(:elixir_delhi_bot, :telegramex, ElixirDelhiBot.TelegramexImpl)
  end
end
