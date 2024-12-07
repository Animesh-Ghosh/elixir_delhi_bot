# ElixirDelhiBot

An attempt at creating a Telegram Bot for the [ElixirDelhi Telegram group](https://t.me/elixirdelhi).

## Features

- [x] Greeting new members
- [ ] Processing [Telegram's Global Commands](https://core.telegram.org/bots/features#global-commands)

## Prequisites
elixir, erlang

## Development
Open Telegram, Message the user "BotFather" to create a bot.
Once the bot is created, get its token number and export it to the bash variable BOT_TOKEN

```bash
mix deps.get && mix deps.compile
iex -S mix
```
As output you should see a repl.
To see some activity, create a telegram group with the bot and add users.
You can see activity in repl by adding logs to process_updates()
```elixir
  @doc """ 
  Processes a list of Updates.
  """ 
  def process_updates([], last_update_id), do: {:ok, last_update_id}

  def process_updates(updates, last_update_id) do
    case first_unprocessed_update(updates, last_update_id) do
      {:error, :no_unprocessed_update} ->
        {:ok, last_update_id}

      {:ok, update} ->
        IO.inspect update 
        process_update(update)
        {:ok, update["update_id"]}
    end 
  end
```
Congratulations! you have succeeded in smoke testing!

## Deployment

Currently, the bot is deployed on [fly.io](https://fly.io). To deploy changes to production, simply run:

```bash
fly launch # first time setup only
fly deploy
```

The bot requires the following environment variables to be set:

1. `BOT_TOKEN` - the token for the Telegram bot. Check out the [docs](https://core.telegram.org/bots#how-do-i-create-a-bot) about how to create a bot and get your token.

2. `DATA_DIR` - the path to the `/data` directory on the server, optional.

It is important to note that the bot runs on a single server currently, since it's polling for [Telegram Updates](https://core.telegram.org/bots/api#update), rather than listening for them.

Although it shouldn't be too difficult to switch to a webhook-based approach 🙃.

## Testing

Currently, exporting necessary environment variables, starting iex and adding a member to the [ElixirDelhiBot Playground](https://t.me/+itLHjWKJnB44MTY1).
