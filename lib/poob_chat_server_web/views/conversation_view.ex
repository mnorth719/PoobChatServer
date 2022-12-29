defmodule PoobChatServerWeb.ConversationView do
  use PoobChatServerWeb, :view
  alias PoobChatServerWeb.Formatting.DateFormatter
  alias PoobChatServerWeb.ConversationView

  def render("index.json", %{conversations: conversations}) do
    render_many(conversations, ConversationView, "conversation.json")
  end

  def render("show.json", %{conversation: conversation}) do
    render_one(conversation, ConversationView, "conversation.json")
  end

  def render("conversation.json", %{conversation: conversation}) do
    %{
      id: conversation.id,
      preview: conversation.preview,
      unread_count: conversation.unread_count,
      updated_at: DateFormatter.naive_to_iso_string(conversation.updated_at)
    }
  end
end
