defmodule ElixirDelhiBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ElixirDelhiBot.Worker.start_link(arg)
      {Finch, name: Telegramex.HTTPClient},
      {CubDB, data_dir: "tmp/cubdb_dir", name: :my_cubdb},
      {ElixirDelhiBot.Worker, nil}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirDelhiBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
