Mox.defmock(ElixirDelhiBot.TelegramexMock, for: ElixirDelhiBot.Telegramex)
Application.put_env(:elixir_delhi_bot, :telegramex, ElixirDelhiBot.TelegramexMock)
ExUnit.start()
