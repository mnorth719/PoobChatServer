defmodule PoobChatServer.AccountsTest do
  use PoobChatServer.DataCase

  alias PoobChatServer.Accounts

  describe "users" do
    alias PoobChatServer.Accounts.User

    import PoobChatServer.AccountsFixtures

    @invalid_attrs %{created_at: nil, hashed_password: nil, password: nil, push_token: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{created_at: ~N[2022-12-26 18:26:00], hashed_password: "some hashed_password", password: "some password", push_token: "some push_token", username: "some username"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.created_at == ~N[2022-12-26 18:26:00]
      assert user.hashed_password == "some hashed_password"
      assert user.password == "some password"
      assert user.push_token == "some push_token"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{created_at: ~N[2022-12-27 18:26:00], hashed_password: "some updated hashed_password", password: "some updated password", push_token: "some updated push_token", username: "some updated username"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.created_at == ~N[2022-12-27 18:26:00]
      assert user.hashed_password == "some updated hashed_password"
      assert user.password == "some updated password"
      assert user.push_token == "some updated push_token"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "user_tokens" do
    alias PoobChatServer.Accounts.UserToken

    import PoobChatServer.AccountsFixtures

    @invalid_attrs %{token: nil, valid: nil}

    test "list_user_tokens/0 returns all user_tokens" do
      user_token = user_token_fixture()
      assert Accounts.list_user_tokens() == [user_token]
    end

    test "get_user_token!/1 returns the user_token with given id" do
      user_token = user_token_fixture()
      assert Accounts.get_user_token!(user_token.id) == user_token
    end

    test "create_user_token/1 with valid data creates a user_token" do
      valid_attrs = %{token: "some token", valid: true}

      assert {:ok, %UserToken{} = user_token} = Accounts.create_user_token(valid_attrs)
      assert user_token.token == "some token"
      assert user_token.valid == true
    end

    test "create_user_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_token(@invalid_attrs)
    end

    test "update_user_token/2 with valid data updates the user_token" do
      user_token = user_token_fixture()
      update_attrs = %{token: "some updated token", valid: false}

      assert {:ok, %UserToken{} = user_token} = Accounts.update_user_token(user_token, update_attrs)
      assert user_token.token == "some updated token"
      assert user_token.valid == false
    end

    test "update_user_token/2 with invalid data returns error changeset" do
      user_token = user_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_token(user_token, @invalid_attrs)
      assert user_token == Accounts.get_user_token!(user_token.id)
    end

    test "delete_user_token/1 deletes the user_token" do
      user_token = user_token_fixture()
      assert {:ok, %UserToken{}} = Accounts.delete_user_token(user_token)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_token!(user_token.id) end
    end

    test "change_user_token/1 returns a user_token changeset" do
      user_token = user_token_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_token(user_token)
    end
  end
end
