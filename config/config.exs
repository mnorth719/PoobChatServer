# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :poob_chat_server,
  ecto_repos: [PoobChatServer.Repo],
  generators: [binary_id: false]

# Configures the endpoint
config :poob_chat_server, PoobChatServerWeb.Endpoint,
  render_errors: [view: PoobChatServerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PoobChatServer.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
