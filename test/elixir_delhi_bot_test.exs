defmodule ElixirDelhiBotTest do
  use ExUnit.Case, async: true
  doctest ElixirDelhiBot

  import Mox

  setup :verify_on_exit!

  describe "process_updates/2" do
    test "returns the same update_id if no updates are present" do
      last_update_id = 1
      assert {:ok, last_update_id} == ElixirDelhiBot.process_updates([], last_update_id)
    end

    test "returns the same update_id if no new updates are present" do
      last_update_id = 1
      updates = [%{"update_id" => 1}]
      assert {:ok, last_update_id} == ElixirDelhiBot.process_updates(updates, last_update_id)
    end

    test "returns the latest update_id if no update_id is present" do
      latest_update_id = 1
      updates = [%{"update_id" => latest_update_id}]
      assert {:ok, latest_update_id} == ElixirDelhiBot.process_updates(updates, nil)
    end

    test "returns the new update_id if a newer update was handled" do
      last_update_id = 1
      new_update_id = 2

      updates = [
        %{
          "update_id" => new_update_id,
          "message" => %{
            "chat" => %{"id" => 1},
            "new_chat_members" => [%{"is_bot" => false, "first_name" => "John"}]
          }
        }
      ]

      expect(ElixirDelhiBot.TelegramexMock, :send_message, 1, fn _chat_id, _text ->
        %{}
      end)

      assert {:ok, new_update_id} == ElixirDelhiBot.process_updates(updates, last_update_id)
    end
  end

  describe "process_update/1" do
    test "returns an error tuple for an unhandled update" do
      assert {:error, :unhandled_update} == ElixirDelhiBot.process_update(%{})
    end

    test "processes new chat members update" do
      new_update_id = 2

      update = %{
        "update_id" => new_update_id,
        "message" => %{
          "chat" => %{"id" => 1},
          "new_chat_members" => [%{"is_bot" => false, "first_name" => "John"}]
        }
      }

      expect(ElixirDelhiBot.TelegramexMock, :send_message, 1, fn _chat_id, _text ->
        %{}
      end)

      ElixirDelhiBot.process_update(update)
    end

    test "processes bot command updates" do
      new_update_id = 2

      update = %{
        "update_id" => new_update_id,
        "message" => %{
          "chat" => %{"id" => 1},
          "entities" => [%{"length" => 6, "offset" => 0, "type" => "bot_command"}],
          "text" => "/start"
        }
      }

      expect(ElixirDelhiBot.TelegramexMock, :send_message, 1, fn _chat_id, _text ->
        %{}
      end)

      ElixirDelhiBot.process_update(update)
    end
  end
end
