defmodule PoobChatServer.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations, primary_key: false) do
      add :id, :string, primary_key: true
      add :preview, :string
      add :unread_count, :integer

      timestamps()
    end
  end
end
