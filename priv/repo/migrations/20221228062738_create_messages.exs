defmodule PoobChatServer.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :string, primary_key: true
      add :content, :string
      add :sender_id, :string
      add :recipient_id, :string
      add :timestamp, :naive_datetime
      add :conversation_id, :string
      add :read, :boolean, default: false, null: false

      timestamps()
    end
  end
end
