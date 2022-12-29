defmodule PoobChatServer.Chat.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  @foreign_key_type :string
  schema "conversations" do
    field :preview, :string
    field :unread_count, :integer
    timestamps()

    many_to_many :users, PoobChatServer.Accounts.User, join_through: "users_conversations"
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:preview, :unread_count, :id])
    |> validate_required([:preview, :unread_count, :id])
  end

  def changeset_update_users(conversation, users) do
    conversation
    |> cast(%{}, [:preview, :unread_count, :id])
    |> put_assoc(:users, users)
  end
end
