defmodule PoobChatServerWeb.UserTokenView do
  use PoobChatServerWeb, :view
  alias PoobChatServerWeb.UserTokenView

  def render("index.json", %{user_tokens: user_tokens}) do
    %{data: render_many(user_tokens, UserTokenView, "user_token.json")}
  end

  def render("show.json", %{user_token: user_token}) do
    %{data: render_one(user_token, UserTokenView, "user_token.json")}
  end

  def render("user_token.json", %{user_token: user_token}) do
    %{
      id: user_token.id,
      token: user_token.token,
      valid: user_token.valid
    }
  end
end
