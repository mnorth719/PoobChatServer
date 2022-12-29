defmodule PoobChatServerWeb.MessageController do
  use PoobChatServerWeb, :controller
  require Logger

  alias PoobChatServer.Chat
  alias PoobChatServer.Chat.Message
  alias PoobChatServer.Accounts.User

  action_fallback PoobChatServerWeb.FallbackController

  def index(conn, _params) do
    messages = Chat.list_messages()
    render(conn, "index.json", messages: messages)
  end

  def create(conn, %{"message" => message_params}) do
    with {:ok, %Message{} = message} <- Chat.create_message_and_convo(message_params) do
      conn
      |> put_status(:created)
      |> render("show.json", message: message)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Chat.get_message!(id)
    render(conn, "show.json", message: message)
  end

  def show(conn, %{}) do
    case conn.assigns[:current_user] do
      %User{} = user -> render(conn, "messages.json", messages: Chat.list_messages(user.id))
      _ -> error(conn, :unauthorized)
    end
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Chat.get_message!(id)

    with {:ok, %Message{} = message} <- Chat.update_message(message, message_params) do
      render(conn, "show.json", message: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Chat.get_message!(id)

    with {:ok, %Message{}} <- Chat.delete_message(message) do
      send_resp(conn, :no_content, "")
    end
  end

  defp error(conn, error) do
    conn
      |> put_view(PoobChatServerWeb.ErrorView)
      |> put_status(error)
  end
end
