defmodule ElixirDelhiBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_delhi_bot,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirDelhiBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.5"},
      {:telegramex, "~> 0.1.1"},
      {:cubdb, "~> 2.0.2"}
    ]
  end
end
