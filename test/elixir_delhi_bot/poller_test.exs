defmodule ElixirDelhiBot.PollerTest do
  use ExUnit.Case, async: true
  doctest ElixirDelhiBot.Poller

  import Mox

  setup :verify_on_exit!

  setup %{last_update_id: last_update_id} do
    start_supervised({CubDB, data_dir: "tmp/cubdb_test_dir", name: :my_cubdb})
    CubDB.put(:my_cubdb, :last_update_id, last_update_id)
  end

  describe "starting the poller" do
    @tag last_update_id: 1
    test "sets the process state from the persisted update_id", context do
      {:ok, pid} = start_supervised({ElixirDelhiBot.Poller, name: :test_poller})
      assert :sys.get_state(pid) == context.last_update_id
    end
  end

  describe "sending the :poll message" do
    setup do
      name = :test_poller
      {:ok, pid} = start_supervised({ElixirDelhiBot.Poller, name: name})
      # Allow the mock to be used in the Poller's process
      Mox.allow(ElixirDelhiBot.TelegramexMock, self(), pid)
      {:ok, %{poller: name}}
    end

    @tag last_update_id: 1
    test "updates the update_id to the latest one", context do
      new_update_id = 2

      expect(ElixirDelhiBot.TelegramexMock, :get_updates, fn ->
        updates = [%{"update_id" => 2}]
        {:ok, %{"result" => updates}}
      end)

      send(context.poller, :poll)

      assert :sys.get_state(context.poller) == new_update_id
      assert CubDB.get(:my_cubdb, :last_update_id) == new_update_id
    end

    @tag last_update_id: 1
    test "does not change the last_update_id when no update can be polled", context do
      expect(ElixirDelhiBot.TelegramexMock, :get_updates, fn ->
        {:error, "Some error occured!"}
      end)

      send(context.poller, :poll)

      assert :sys.get_state(context.poller) == context.last_update_id
      assert CubDB.get(:my_cubdb, :last_update_id) == context.last_update_id
    end
  end
end
