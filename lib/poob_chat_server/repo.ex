defmodule PoobChatServer.Repo do
  use Ecto.Repo,
    otp_app: :poob_chat_server,
    adapter: Ecto.Adapters.Postgres
end
