defmodule PoobChatServer.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PoobChatServer.Chat` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        read: true,
        recipient_id: "some recipient_id",
        sender_id: "some sender_id",
        timestamp: ~N[2022-12-27 06:27:00]
      })
      |> PoobChatServer.Chat.create_message()

    message
  end

  @doc """
  Generate a conversation.
  """
  def conversation_fixture(attrs \\ %{}) do
    {:ok, conversation} =
      attrs
      |> Enum.into(%{
        last_updated: ~N[2022-12-27 17:56:00],
        preview: "some preview",
        unread_count: 42
      })
      |> PoobChatServer.Chat.create_conversation()

    conversation
  end
end
