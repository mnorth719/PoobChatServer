defmodule PoobChatServerWeb.UserTokenController do
  use PoobChatServerWeb, :controller

  alias PoobChatServer.Accounts
  alias PoobChatServer.Accounts.UserToken

  action_fallback PoobChatServerWeb.FallbackController

  def index(conn, _params) do
    user_tokens = Accounts.list_user_tokens()
    render(conn, "index.json", user_tokens: user_tokens)
  end

  def create(conn, %{"user_token" => user_token_params}) do
    with {:ok, %UserToken{} = user_token} <- Accounts.create_user_token(user_token_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user_token: user_token)
    end
  end

  def show(conn, %{"id" => id}) do
    user_token = Accounts.get_user_token!(id)
    render(conn, "show.json", user_token: user_token)
  end

  def update(conn, %{"id" => id, "user_token" => user_token_params}) do
    user_token = Accounts.get_user_token!(id)

    with {:ok, %UserToken{} = user_token} <- Accounts.update_user_token(user_token, user_token_params) do
      render(conn, "show.json", user_token: user_token)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_token = Accounts.get_user_token!(id)

    with {:ok, %UserToken{}} <- Accounts.delete_user_token(user_token) do
      send_resp(conn, :no_content, "")
    end
  end
end
