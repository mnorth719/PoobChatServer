defmodule PoobChatServer.Accounts.Friend do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger
  @fields [:user_id, :friend_id]

  schema "friends" do
    field :user_id, :string
    field :friend_id, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    Logger.log(:debug, params)
    struct
    |> cast(id_if_missing(params), @fields)
    |> unique_constraint(
      [:user_id, :friend_id],
      name: :friends_person_id_relation_id_index
    )
    |> unique_constraint(
      [:friend_id, :user_id],
      name: :friends_relation_id_user_id_index
    )
  end

  defp id_if_missing(params) do
    case Map.get(params, :id) do
      nil -> Map.put(params, :id, UUID.uuid1())
      _ -> params
    end
  end
end
