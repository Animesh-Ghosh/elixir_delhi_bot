# ElixirDelhiBot

An attempt at creating a Telegram Bot for the [ElixirDelhi Telegram group](https://t.me/elixirdelhi).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_delhi_bot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_delhi_bot, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/elixir_delhi_bot>.

## Testing

Currently, starting iex and running the commands below to get chat updates

```elixir
client = %Telegramex.Client{token: Application.fetch_env!(:elixir_delhi_bot, :bot_token)}
Telegramex.get_updates(client)
```