defmodule PoobChatServerWeb.FriendController do
  use PoobChatServerWeb, :controller
  require Logger

  alias PoobChatServer.Accounts
  alias PoobChatServer.Accounts.Friend

  action_fallback PoobChatServerWeb.FallbackController

  def index(conn, _params) do
    # user_id = conn.assigns[:current_user].id
    # friends = Accounts.list_friends(user_id)
    friends = Accounts.list_users()
    render(conn, "index.json", friends: friends)
  end

  def create(conn, %{"id" => id}) do
    user_id = conn.assigns[:current_user].id
    case Accounts.add_friend(user_id, id) do
      {:ok, _ } -> friend_created(conn)
      {:error, err} -> error(conn, err)
    end
  end

  defp error(conn, error) do
    conn
      |> put_view(PoobChatServerWeb.ErrorView)
      |> put_status(error)
  end

  defp friend_created(conn) do
    conn
    |> put_status(:created)
    |> send_resp(:no_content, "")
  end
end
