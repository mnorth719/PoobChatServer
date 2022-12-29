defmodule PoobChatServerWeb.ConversationController do
  use PoobChatServerWeb, :controller

  alias PoobChatServer.Chat
  alias PoobChatServer.Chat.Conversation

  action_fallback PoobChatServerWeb.FallbackController

  def index(conn, _params) do
    conversations = Chat.list_conversations()
    render(conn, "index.json", conversations: conversations)
  end

  def show(conn, %{"id" => id}) do
    conversation = Chat.get_conversation!(id)
    render(conn, "show.json", conversation: conversation)
  end

  def delete(conn, %{"id" => id}) do
    conversation = Chat.get_conversation!(id)

    with {:ok, %Conversation{}} <- Chat.delete_conversation(conversation) do
      send_resp(conn, :no_content, "")
    end
  end
end
