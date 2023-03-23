defmodule PoobChatServerWeb.FriendController do
  use PoobChatServerWeb, :controller
  require Logger

  alias PoobChatServer.Accounts

  action_fallback PoobChatServerWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.assigns[:current_user].id
    friends = Accounts.list_friends(user_id)
    # friends = Accounts.list_users()
    render(conn, "index.json", friends: friends)
  end

  def create(conn, %{"id" => id}) do
    user_id = conn.assigns[:current_user].id
    case Accounts.add_friend(user_id, id) do
      {:ok, friend } -> render(conn, "friend.json", friend: friend)
      {:error, err} -> error(conn, err)
    end
  end

  def create(conn, %{"username" => un}) do
    user_id = conn.assigns[:current_user].id
    friend = Accounts.add_friend_by_username(user_id, un)
    render(conn, "friend.json", friend: friend)
  end

  def delete(conn, %{"id" => id}) do
    user_id = conn.assigns[:current_user].id
    case Accounts.delete_friend(user_id, id) do
      {1, _} -> send_resp(conn, :no_content, "")
      {:error, err} -> error(conn, err)
    end
  end

  defp error(conn, error) do
    conn
      |> put_view(PoobChatServerWeb.ErrorView)
      |> put_status(error)
  end
end
