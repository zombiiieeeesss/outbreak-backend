# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :registrar,
  namespace: Registrar

# Configures the endpoint
config :registrar, Registrar.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zBzT6ZfveNRIWzEoWW2HQlAvD+836/2txKrC3yxJK5fQFU0a4m8KDmErbhTPKHqV",
  render_errors: [view: Registrar.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Registrar.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :guardian, Guardian,
 issuer: "Registrar",
 ttl: { 30, :days },
 allowed_drift: 2000,
 secret_key: "cHvvEICoN0azBi61y6np0nC35e9cObFsH3Yio6LbEtFkwCG7qzqo/qFtVJ+TLTsA",
 serializer: MyApp.GuardianSerializer

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
