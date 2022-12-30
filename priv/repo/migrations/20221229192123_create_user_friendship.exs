defmodule PoobChatServer.Repo.Migrations.CreateUserFriendship do
  use Ecto.Migration

  def change do
    create table(:friends) do
      add :user_id, references(:users, type: :string)
      add :friend_id, references(:users, type: :string)
      timestamps()
    end

    create index(:friends, [:user_id])
    create index(:friends, [:friend_id])

    create unique_index(
      :friends,
      [:user_id, :friend_id],
      name: :friends_person_id_relation_id_index
    )

    create unique_index(
      :friends,
      [:friend_id, :user_id],
      name: :friends_relation_id_user_id_index
    )
  end
end
