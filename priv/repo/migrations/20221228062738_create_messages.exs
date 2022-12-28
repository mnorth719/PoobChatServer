defmodule PoobChatServer.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :sender_id, :string
      add :recipient_id, :string
      add :timestamp, :naive_datetime
      add :read, :boolean, default: false, null: false

      timestamps()
    end
  end
end
