import Config
config :elixir_delhi_bot, :bot_token, System.fetch_env!("BOT_TOKEN")
config :elixir_delhi_bot, :data_dir, System.get_env("DATA_DIR", "tmp/cubdb_dir")
