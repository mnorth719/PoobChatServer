defmodule PoobChatWeb.PageController do
  use PoobChatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
