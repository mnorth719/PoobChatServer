defmodule PoobChatServerWeb.UserTokenControllerTest do
  use PoobChatServerWeb.ConnCase

  import PoobChatServer.AccountsFixtures

  alias PoobChatServer.Accounts.UserToken

  @create_attrs %{
    token: "some token",
    valid: true
  }
  @update_attrs %{
    token: "some updated token",
    valid: false
  }
  @invalid_attrs %{token: nil, valid: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_tokens", %{conn: conn} do
      conn = get(conn, Routes.user_token_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_token" do
    test "renders user_token when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_token_path(conn, :create), user_token: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_token_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "token" => "some token",
               "valid" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_token_path(conn, :create), user_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_token" do
    setup [:create_user_token]

    test "renders user_token when data is valid", %{conn: conn, user_token: %UserToken{id: id} = user_token} do
      conn = put(conn, Routes.user_token_path(conn, :update, user_token), user_token: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_token_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "token" => "some updated token",
               "valid" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_token: user_token} do
      conn = put(conn, Routes.user_token_path(conn, :update, user_token), user_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_token" do
    setup [:create_user_token]

    test "deletes chosen user_token", %{conn: conn, user_token: user_token} do
      conn = delete(conn, Routes.user_token_path(conn, :delete, user_token))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_token_path(conn, :show, user_token))
      end
    end
  end

  defp create_user_token(_) do
    user_token = user_token_fixture()
    %{user_token: user_token}
  end
end
