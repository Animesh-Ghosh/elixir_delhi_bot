defmodule ElixirDelhiBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: Telegramex.HTTPClient},
      {CubDB, data_dir: Application.fetch_env!(:elixir_delhi_bot, :data_dir), name: :my_cubdb},
      {ElixirDelhiBot.Poller, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirDelhiBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
