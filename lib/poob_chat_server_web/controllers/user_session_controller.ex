defmodule PoobChatServerWeb.UserSessionController do
  use PoobChatServerWeb, :controller
  require Logger

  alias PoobChatServer.Accounts
  alias PoobChatServer.Accounts.User
  alias PoobChatServer.Token

  action_fallback PoobChatServerWeb.FallbackController

  @spec create(any, map) :: any
  def create(conn, %{"username" => username, "password" => password}) do
    Logger.log(:debug, "Looking up account")
    case Accounts.get_user_by_username_and_password(username, password) do
      %User{} = user -> finish_login(conn, user)
      _ -> invalid_login(conn)
    end
  end

  defp finish_login(conn, %User{} = user) do
    token = Token.sign(%{user_id: user.id})
    conn
      |> put_view(PoobChatServerWeb.UserView)
      |> put_status(:created)
      |> render("registration.json", %{user: user, token: token})
  end

  defp invalid_login(conn) do
    conn
      |> put_view(PoobChatServerWeb.ErrorView)
      |> put_status(:bad_request)
      |> render("error.json", %{error: "Invalid email or password"})
  end
end
