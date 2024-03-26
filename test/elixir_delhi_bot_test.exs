defmodule ElixirDelhiBotTest do
  use ExUnit.Case
  doctest ElixirDelhiBot

  test "greets the world" do
    assert ElixirDelhiBot.hello() == :world
  end
end
