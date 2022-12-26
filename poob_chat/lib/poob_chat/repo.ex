defmodule PoobChat.Repo do
  use Ecto.Repo,
    otp_app: :poob_chat,
    adapter: Ecto.Adapters.Postgres
end
