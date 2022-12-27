defmodule PoobChatServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :created_at, :naive_datetime
    field :hashed_password, :string, redact: true
    field :password, :string, virtual: true, redact: true
    field :push_token, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :hashed_password, :created_at, :push_token])
    |> validate_required([:username, :password, :hashed_password, :created_at])
  end
end
