defmodule PoobChatServer.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias PoobChatServer.Accounts
  alias PoobChatServer.Accounts.User
  alias NaiveDateTime
  alias PoobChatServer.Repo

  alias PoobChatServer.Chat.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Returns the list of messages for a user_id.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages(user_id) do
    query = from(
      m in Message,
      where: m.sender_id == ^user_id or m.recipient_id == ^user_id,
      order_by: [desc: m.timestamp]
    )
    Repo.all(query)
  end

  def list_convos(user_id) do
    Repo.get(User, user_id)
      |> Ecto.assoc(:conversations)
      |> Repo.all()
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def create_message_and_convo(attrs \\ %{}) do
    convo_id = generated_conversation_id(attrs)
    attrs = Map.put(attrs, "conversation_id", convo_id)
    create_message(attrs)
    case upsert_convo(convo_id,
      %{
        id: convo_id,
        preview: Map.get(attrs, "content"),
        unread_count: 0
      }
    ) do
      {:ok, conv} -> upsert_user_conversations(conv, Message.user_ids(attrs))
      _ -> raise "unable to associate convo"
    end
    create_message(attrs)
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  alias PoobChatServer.Chat.Conversation

  @doc """
  Returns the list of conversations.

  ## Examples

      iex> list_conversations()
      [%Conversation{}, ...]

  """
  def list_conversations do
    Repo.all(Conversation)
  end

  @doc """
  Gets a single conversation.

  Raises `Ecto.NoResultsError` if the Conversation does not exist.

  ## Examples

      iex> get_conversation!(123)
      %Conversation{}

      iex> get_conversation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation!(id), do: Repo.get!(Conversation, id)

  @doc """
  Creates a conversation.

  ## Examples

      iex> create_conversation(%{field: value})
      {:ok, %Conversation{}}

      iex> create_conversation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversation(attrs \\ %{}) do
    %Conversation{}
    |> Conversation.changeset(attrs)
    |> Repo.insert()
  end

  def upsert_convo(id, attrs \\ %{}) do
    case Repo.get(Conversation, id) do
      %Conversation{} = conv -> update_conversation(conv, attrs)
      _ -> create_conversation(attrs)
    end
  end

  def upsert_user_conversations(conversation, user_ids)
    when is_list(user_ids) do
    users =
      User
      |> where([u], u.id in ^user_ids)
      |> Repo.all()
    with {:ok, _struct} <-
           conversation
           |> Repo.preload([:users])
           |> Conversation.changeset_update_users(users)
           |> Repo.update()
            do
      {:ok, get_conversation!(conversation.id)}
    else
      error ->
        error
    end
  end

  @doc """
  Updates a conversation.

  ## Examples

      iex> update_conversation(conversation, %{field: new_value})
      {:ok, %Conversation{}}

      iex> update_conversation(conversation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a conversation.

  ## Examples

      iex> delete_conversation(conversation)
      {:ok, %Conversation{}}

      iex> delete_conversation(conversation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_conversation(%Conversation{} = conversation) do
    Repo.delete(conversation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking conversation changes.

  ## Examples

      iex> change_conversation(conversation)
      %Ecto.Changeset{data: %Conversation{}}

  """
  def change_conversation(%Conversation{} = conversation, attrs \\ %{}) do
    Conversation.changeset(conversation, attrs)
  end

  def generated_conversation_id(%{"sender_id" => sid, "recipient_id" => rid}) do
    raw_id = [sid, rid]
            |> Enum.sort()
            |> Enum.join()
    :crypto.hash(:sha256, raw_id)
      |> Base.encode16()
  end
end
