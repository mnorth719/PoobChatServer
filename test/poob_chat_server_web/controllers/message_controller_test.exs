defmodule PoobChatServerWeb.MessageControllerTest do
  use PoobChatServerWeb.ConnCase

  import PoobChatServer.ChatFixtures

  alias PoobChatServer.Chat.Message

  @create_attrs %{
    content: "some content",
    read: true,
    recipient_id: "some recipient_id",
    sender_id: "some sender_id",
    timestamp: ~N[2022-12-27 06:27:00]
  }
  @update_attrs %{
    content: "some updated content",
    read: false,
    recipient_id: "some updated recipient_id",
    sender_id: "some updated sender_id",
    timestamp: ~N[2022-12-28 06:27:00]
  }
  @invalid_attrs %{content: nil, read: nil, recipient_id: nil, sender_id: nil, timestamp: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all messages", %{conn: conn} do
      conn = get(conn, Routes.message_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create message" do
    test "renders message when data is valid", %{conn: conn} do
      conn = post(conn, Routes.message_path(conn, :create), message: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.message_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "content" => "some content",
               "read" => true,
               "recipient_id" => "some recipient_id",
               "sender_id" => "some sender_id",
               "timestamp" => "2022-12-27T06:27:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.message_path(conn, :create), message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update message" do
    setup [:create_message]

    test "renders message when data is valid", %{conn: conn, message: %Message{id: id} = message} do
      conn = put(conn, Routes.message_path(conn, :update, message), message: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.message_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "content" => "some updated content",
               "read" => false,
               "recipient_id" => "some updated recipient_id",
               "sender_id" => "some updated sender_id",
               "timestamp" => "2022-12-28T06:27:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, message: message} do
      conn = put(conn, Routes.message_path(conn, :update, message), message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete message" do
    setup [:create_message]

    test "deletes chosen message", %{conn: conn, message: message} do
      conn = delete(conn, Routes.message_path(conn, :delete, message))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.message_path(conn, :show, message))
      end
    end
  end

  defp create_message(_) do
    message = message_fixture()
    %{message: message}
  end
end
