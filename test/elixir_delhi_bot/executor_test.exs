defmodule ElixirDelhiBot.ExecutorTest do
  use ExUnit.Case, async: true

  import Mox

  setup :verify_on_exit!

  describe "bot_command?/1" do
    test "returns true when a bot command is received" do
      update = %{
        "update_id" => 1,
        "message" => %{
          "chat" => %{"id" => 1},
          "entities" => [%{"type" => "bot_command"}],
          "text" => "/start"
        }
      }

      assert ElixirDelhiBot.Executor.bot_command?(update)
    end

    test "returns false when no bot command is received" do
      update = %{
        "update_id" => 1,
        "message" => %{
          "chat" => %{"id" => 1},
          "text" => "foo bar"
        }
      }

      refute ElixirDelhiBot.Executor.bot_command?(update)
    end
  end

  describe "handle_bot_command/1" do
    test "sends the intro message for the /start command" do
      expected_chat_id = 1

      expect(ElixirDelhiBot.TelegramexMock, :send_message, 1, fn chat_id, _text ->
        assert chat_id == expected_chat_id
        %{}
      end)

      update = %{
        "update_id" => 1,
        "message" => %{
          "chat" => %{"id" => expected_chat_id},
          "entities" => [
            %{"type" => "bot_command"}
          ],
          "text" => "/start"
        }
      }

      ElixirDelhiBot.Executor.handle_bot_command(update)
    end
  end
end
