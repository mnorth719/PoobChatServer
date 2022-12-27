defmodule PoobChatServer.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PoobChatServer.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        created_at: ~N[2022-12-26 18:26:00],
        hashed_password: "some hashed_password",
        password: "some password",
        push_token: "some push_token",
        username: "some username"
      })
      |> PoobChatServer.Accounts.create_user()

    user
  end

  @doc """
  Generate a user_token.
  """
  def user_token_fixture(attrs \\ %{}) do
    {:ok, user_token} =
      attrs
      |> Enum.into(%{
        token: "some token",
        valid: true
      })
      |> PoobChatServer.Accounts.create_user_token()

    user_token
  end
end
