defmodule PoobChatServerWeb.UserView do
  use PoobChatServerWeb, :view
  alias PoobChatServerWeb.Formatting.DateFormatter
  alias PoobChatServerWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      inserted_at: DateFormatter.naive_to_iso_string(user.inserted_at),
      push_token: user.push_token
    }
  end

  def render("registration.json", %{user: user, token: token}) do
    %{
      user: %{
        id: user.id,
        username: user.username,
        inserted_at: DateFormatter.naive_to_iso_string(user.inserted_at),
        push_token: user.push_token,
      },
     token: token
    }
  end
end
