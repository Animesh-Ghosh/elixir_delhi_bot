defmodule ElixirDelhiBot.GreeterTest do
  use ExUnit.Case, async: true
  doctest ElixirDelhiBot.Greeter

  import Mox

  setup :verify_on_exit!

  describe "new_chat_members_joined?/1" do
    test "returns true when new chat members have joined" do
      update = %{
        "message" => %{
          "chat" => %{"id" => 1},
          "new_chat_members" => [%{"id" => 1, "is_bot" => false, "first_name" => "John"}]
        }
      }

      assert ElixirDelhiBot.Greeter.new_chat_members_joined?(update)
    end

    test "returns false when no new chat members joined" do
      update = %{
        "message" => %{
          "chat" => %{"id" => 1},
          "text" => "foo bar"
        }
      }

      refute ElixirDelhiBot.Greeter.new_chat_members_joined?(update)
    end
  end

  describe "handle_new_chat_members/1" do
    test "does not greet new bot members" do
      expect(ElixirDelhiBot.TelegramexMock, :send_message, 0, fn _chat_id, _text -> %{} end)

      update = %{
        "message" => %{
          "chat" => %{"id" => 1},
          "new_chat_members" => [
            %{"id" => 1, "is_bot" => true, "first_name" => "Foo Bot"}
          ]
        }
      }

      ElixirDelhiBot.Greeter.handle_new_chat_members(update)
    end

    test "greets new human members" do
      expected_chat_id = 1
      first_name = "John"

      expect(ElixirDelhiBot.TelegramexMock, :send_message, 1, fn chat_id, text ->
        assert chat_id == expected_chat_id

        assert text in [
                 "A wild John appeared!",
                 "John just joined. Everyone, look busy!",
                 "Welcome John. We hope you brought pizza.",
                 ~s["John" |> welcome() |> to_the_group()],
                 ~s(Pattern matched: %{new_member: "John"}),
                 ~s[spawn(fn -> greet("John") end)],
                 ~s("John" has been added to the process registry!),
                 ~s(GenServer started for "John"!)
               ]

        %{}
      end)

      update = %{
        "message" => %{
          "chat" => %{"id" => expected_chat_id},
          "new_chat_members" => [
            %{"id" => 1, "is_bot" => false, "first_name" => first_name}
          ]
        }
      }

      ElixirDelhiBot.Greeter.handle_new_chat_members(update)
    end

    test "greets new members with Unicode names" do
      expected_chat_id = 1
      first_name = "José 🦭"

      expect(ElixirDelhiBot.TelegramexMock, :send_message, 1, fn chat_id, text ->
        assert chat_id == expected_chat_id

        assert text in [
                 "A wild José 🦭 appeared!",
                 "José 🦭 just joined. Everyone, look busy!",
                 "Welcome José 🦭. We hope you brought pizza.",
                 ~s["José 🦭" |> welcome() |> to_the_group()],
                 ~s(Pattern matched: %{new_member: "José 🦭"}),
                 ~s[spawn(fn -> greet("José 🦭") end)],
                 ~s("José 🦭" has been added to the process registry!),
                 ~s(GenServer started for "José 🦭"!)
               ]

        %{}
      end)

      update = %{
        "message" => %{
          "chat" => %{"id" => expected_chat_id},
          "new_chat_members" => [
            %{"id" => 1, "is_bot" => false, "first_name" => first_name}
          ]
        }
      }

      ElixirDelhiBot.Greeter.handle_new_chat_members(update)
    end
  end
end
