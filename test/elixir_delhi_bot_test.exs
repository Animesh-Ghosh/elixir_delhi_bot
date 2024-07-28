defmodule ElixirDelhiBotTest do
  use ExUnit.Case, async: true
  doctest ElixirDelhiBot

  test "greets the world" do
    assert ElixirDelhiBot.hello() == :world
  end
end
