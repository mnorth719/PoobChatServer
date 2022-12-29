defmodule PoobChatServerWeb.ConversationControllerTest do
  use PoobChatServerWeb.ConnCase

  import PoobChatServer.ChatFixtures

  alias PoobChatServer.Chat.Conversation

  @create_attrs %{
    last_updated: ~N[2022-12-27 17:56:00],
    preview: "some preview",
    unread_count: 42
  }
  @update_attrs %{
    last_updated: ~N[2022-12-28 17:56:00],
    preview: "some updated preview",
    unread_count: 43
  }
  @invalid_attrs %{last_updated: nil, preview: nil, unread_count: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all conversations", %{conn: conn} do
      conn = get(conn, Routes.conversation_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create conversation" do
    test "renders conversation when data is valid", %{conn: conn} do
      conn = post(conn, Routes.conversation_path(conn, :create), conversation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.conversation_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "last_updated" => "2022-12-27T17:56:00",
               "preview" => "some preview",
               "unread_count" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.conversation_path(conn, :create), conversation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update conversation" do
    setup [:create_conversation]

    test "renders conversation when data is valid", %{conn: conn, conversation: %Conversation{id: id} = conversation} do
      conn = put(conn, Routes.conversation_path(conn, :update, conversation), conversation: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.conversation_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "last_updated" => "2022-12-28T17:56:00",
               "preview" => "some updated preview",
               "unread_count" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, conversation: conversation} do
      conn = put(conn, Routes.conversation_path(conn, :update, conversation), conversation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete conversation" do
    setup [:create_conversation]

    test "deletes chosen conversation", %{conn: conn, conversation: conversation} do
      conn = delete(conn, Routes.conversation_path(conn, :delete, conversation))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.conversation_path(conn, :show, conversation))
      end
    end
  end

  defp create_conversation(_) do
    conversation = conversation_fixture()
    %{conversation: conversation}
  end
end
