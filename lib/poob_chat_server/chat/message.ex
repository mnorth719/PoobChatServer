defmodule PoobChatServer.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  @foreign_key_type :string
  schema "messages" do
    field :content, :string
    field :read, :boolean, default: false
    field :recipient_id, :string
    field :sender_id, :string
    field :timestamp, :naive_datetime
    field :conversation_id, :string
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> id_if_missing()
    |> cast(attrs, [:content, :sender_id, :recipient_id, :timestamp, :read, :id, :conversation_id])
    |> validate_required([:content, :sender_id, :recipient_id, :timestamp, :read, :id, :conversation_id])
  end

  defp id_if_missing(changeset) do
    case Map.get(changeset, :id) do
      nil -> Map.put(changeset, :id, UUID.uuid1())
      _ -> changeset
    end
  end

  def user_ids(%{"sender_id" => sid, "recipient_id" => rid}) do
    [sid, rid]
  end
end
