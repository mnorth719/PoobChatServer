defmodule PoobChatServerWeb.ConversationController do
  use PoobChatServerWeb, :controller

  alias PoobChatServer.Chat
  alias PoobChatServer.Chat.Conversation

  action_fallback PoobChatServerWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.assigns[:current_user].id
    render(conn, "index.json", conversations: Chat.list_convos(user_id), user_id: user_id)
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
