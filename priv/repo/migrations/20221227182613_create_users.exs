defmodule PoobChatServer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :password, :string
      add :hashed_password, :string
      add :created_at, :naive_datetime
      add :push_token, :string

      timestamps()
    end
  end
end
