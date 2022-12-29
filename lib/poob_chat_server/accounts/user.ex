defmodule PoobChatServer.Accounts.User do
  alias PoobChatServer.Accounts.Friend
  alias PoobChatServer.Chat.Conversation
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  @primary_key {:id, :string, []}
  @foreign_key_type :string
  schema "users" do
    field :created_at, :naive_datetime
    field :hashed_password, :string, redact: true
    field :password, :string, virtual: true, redact: true
    field :push_token, :string
    field :username, :string
    timestamps()

    many_to_many :conversations,
                 Conversation,
                 join_through: "users_conversations"

    many_to_many :friends,
                 User,
                 join_through: Friend,
                 join_keys: [user_id: :id, friend_id: :id]

    many_to_many :reverse_friends,
                 User,
                 join_through: Friend,
                 join_keys: [friend_id: :id, user_id: :id]
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%PoobChatServer.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :hashed_password, :created_at, :push_token, :id])
    |> validate_required([:username, :password, :hashed_password, :created_at, :id])
  end

  def registration_changeset(user, attrs, opts \\ []) do
    attrs = id_if_missing(attrs)
    user
    |> cast(attrs, [:username, :password, :id])
    |> id_if_missing()
    |> validate_username()
    |> validate_password(opts)
  end

  defp validate_username(changeset) do
    Logger.log(:debug, IO.inspect(changeset))
    changeset
    |> validate_required([:username])
    |> validate_length(:username, max: 40)
    |> unsafe_validate_unique(:username, PoobChatServer.Repo)
    |> unique_constraint(:username)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 10, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp id_if_missing(attrs) do
    case Map.get(attrs, "id") do
      nil -> Map.put(attrs, "id", UUID.uuid1())
      _ -> attrs
    end
  end
end
