# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  namespace: API

# Configures the endpoint
config :api, API.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zBzT6ZfveNRIWzEoWW2HQlAvD+836/2txKrC3yxJK5fQFU0a4m8KDmErbhTPKHqV",
  render_errors: [view: API.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: API.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :verk, queues: [default: 25, priority: 10],
             max_retry_count: 10,
             poll_interval: {:system, :integer, "VERK_POLL_INTERVAL", 5000},
             start_job_log_level: :info,
             done_job_log_level: :info,
             fail_job_log_level: :info,
             node_id: "1",
             redis_url: {:system, "VERK_REDIS_URL", "redis://127.0.0.1:6379"}

# This app does not have any Repos
config :api, ecto_repos: []

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
