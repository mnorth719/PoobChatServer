defmodule PoobChatServerWeb.UserController do
  use PoobChatServerWeb, :controller
  require Logger

  alias PoobChatServer.Accounts
  alias PoobChatServer.Accounts.User
  alias PoobChatServer.Token

  action_fallback PoobChatServerWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, params = %{"username" => _username, "password" => _password}) do
    with {:ok, %User{} = user} <- Accounts.create_user(params),
         token <- Token.sign(%{user_id: user.id})
    do
        conn
          |> put_status(:created)
          |> render("registration.json", %{user: user, token: token})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
