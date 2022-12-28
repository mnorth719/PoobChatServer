defmodule PoobChatServer.ChatTest do
  use PoobChatServer.DataCase

  alias PoobChatServer.Chat

  describe "messages" do
    alias PoobChatServer.Chat.Message

    import PoobChatServer.ChatFixtures

    @invalid_attrs %{content: nil, read: nil, recipient_id: nil, sender_id: nil, timestamp: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Chat.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Chat.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{content: "some content", read: true, recipient_id: "some recipient_id", sender_id: "some sender_id", timestamp: ~N[2022-12-27 06:27:00]}

      assert {:ok, %Message{} = message} = Chat.create_message(valid_attrs)
      assert message.content == "some content"
      assert message.read == true
      assert message.recipient_id == "some recipient_id"
      assert message.sender_id == "some sender_id"
      assert message.timestamp == ~N[2022-12-27 06:27:00]
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{content: "some updated content", read: false, recipient_id: "some updated recipient_id", sender_id: "some updated sender_id", timestamp: ~N[2022-12-28 06:27:00]}

      assert {:ok, %Message{} = message} = Chat.update_message(message, update_attrs)
      assert message.content == "some updated content"
      assert message.read == false
      assert message.recipient_id == "some updated recipient_id"
      assert message.sender_id == "some updated sender_id"
      assert message.timestamp == ~N[2022-12-28 06:27:00]
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_message(message, @invalid_attrs)
      assert message == Chat.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Chat.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Chat.change_message(message)
    end
  end
end
