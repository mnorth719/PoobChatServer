defmodule PoobChatServerWeb.MessageView do
  use PoobChatServerWeb, :view
  alias PoobChatServerWeb.MessageView

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("messages.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      content: message.content,
      sender_id: message.sender_id,
      recipient_id: message.recipient_id,
      timestamp: message.timestamp,
      read: message.read
    }
  end
end
