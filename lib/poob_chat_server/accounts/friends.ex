defmodule PoobChatServer.Accounts.Friend do
  use Ecto.Schema
  import Ecto.Changeset
  @fields [:user_id, :friend_id]

  schema "friends" do
    field :user_id, :string
    field :friend_id, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> unique_constraint(
      [:user_id, :friend_id],
      name: :friends_person_id_relation_id_index
    )
    |> unique_constraint(
      [:friend_id, :user_id],
      name: :friends_relation_id_user_id_index
    )
  end
end
