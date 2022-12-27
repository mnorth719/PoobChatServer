defmodule PoobChatServer.Repo.Migrations.CreateUserTokens do
  use Ecto.Migration

  def change do
    create table(:user_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :string
      add :valid, :boolean, default: false, null: false

      timestamps()
    end
  end
end
