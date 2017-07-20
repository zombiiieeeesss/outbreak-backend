# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :outbreak_backend_web,
  namespace: OutbreakBackend.Web,
  ecto_repos: [OutbreakBackend.Repo]

# Configures the endpoint
config :outbreak_backend_web, OutbreakBackend.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0fiGm0Jq0W2ByJk0R0YIqpvyDVZfh6LDoaCGqy15r39L5PPkd5gKs7VvuF+DDvSy",
  render_errors: [view: OutbreakBackend.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: OutbreakBackend.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :outbreak_backend_web, :generators,
  context_app: :outbreak_backend

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
