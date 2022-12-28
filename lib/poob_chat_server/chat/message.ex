defmodule PoobChatServer.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string
    field :read, :boolean, default: false
    field :recipient_id, :string
    field :sender_id, :string
    field :timestamp, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :sender_id, :recipient_id, :timestamp, :read])
    |> validate_required([:content, :sender_id, :recipient_id, :timestamp, :read])
  end
end
