defmodule PoobChatServerWeb.MessageView do
  use PoobChatServerWeb, :view
  alias PoobChatServerWeb.Formatting.DateFormatter
  alias PoobChatServerWeb.MessageView

  def render("index.json", %{messages: messages}) do
    render_many(messages, MessageView, "message.json")
  end

  def render("messages.json", %{messages: messages}) do
    render_many(messages, MessageView, "message.json")
  end

  def render("show.json", %{message: message}) do
    render_one(message, MessageView, "message.json")
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      content: message.content,
      sender_id: message.sender_id,
      recipient_id: message.recipient_id,
      timestamp: DateFormatter.naive_to_iso_string(message.timestamp),
      read: message.read,
      conversation_id: message.conversation_id
    }
  end
end
