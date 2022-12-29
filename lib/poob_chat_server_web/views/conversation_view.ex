defmodule PoobChatServerWeb.ConversationView do
  use PoobChatServerWeb, :view
  alias PoobChatServerWeb.Formatting.DateFormatter
  alias PoobChatServerWeb.ConversationView
  require Logger

  def render("index.json", %{conversations: conversations, user_id: user_id}) do
    Enum.map(conversations, fn convo ->
      render(ConversationView, "conversation.json", conversation: convo, user_id: user_id)
    end)
  end

  def render("show.json", attrs) do
    render_one(attrs, ConversationView, "conversation.json")
  end

  def render("conversation.json", %{conversation: conversation, user_id: user_id}) do
    user = conversation.users
      |> Enum.filter(fn u -> u.id != user_id end)
      |> List.first("Unknown")
    %{
      id: conversation.id,
      preview: conversation.preview,
      unread_count: conversation.unread_count,
      updated_at: DateFormatter.naive_to_iso_string(conversation.updated_at),
      username: user.username
    }
  end
end
