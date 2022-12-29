defmodule PoobChatServerWeb.FriendView do
  use PoobChatServerWeb, :view
  alias PoobChatServerWeb.Formatting.DateFormatter
  alias PoobChatServerWeb.FriendView

  def render("index.json", %{friends: friends}) do
    render_many(friends, FriendView, "friend.json")
  end

  def render("show.json", %{friend: friend}) do
    render_one(friend, FriendView, "friend.json")
  end

  def render("friend.json", %{friend: friend}) do
    %{
      id: friend.id,
      username: friend.username,
      inserted_at: DateFormatter.naive_to_iso_string(friend.inserted_at),
    }
  end
end
