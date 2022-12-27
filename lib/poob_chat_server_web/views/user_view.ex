defmodule PoobChatServerWeb.UserView do
  use PoobChatServerWeb, :view
  alias PoobChatServerWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      created_at: user.created_at,
      push_token: user.push_token
    }
  end
end
