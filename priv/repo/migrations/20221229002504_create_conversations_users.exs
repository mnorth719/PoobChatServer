defmodule PoobChatServer.Repo.Migrations.CreateConversationsUsers do
  use Ecto.Migration

  def change do
    create table(:users_conversations) do
      add :user_id, references(:users, type: :string)
      add :conversation_id, references(:conversations, type: :string)
    end

    create unique_index(:users_conversations, [:user_id, :conversation_id])
  end
end
