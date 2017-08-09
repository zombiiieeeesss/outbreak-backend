use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api, API.Web.Endpoint,
  http: [port: 4001],
  server: false

config :guardian, Guardian,
 issuer: "API",
 ttl: {1, :days},
 allowed_drift: 2000,
 secret_key: "cHvvEICoN0azBi61y6np0nC35e9cObFsH3Yio6LbEtFkwCG7qzqo/qFtVJ+TLTsA",
 serializer: API.GuardianSerializer

# Print only warnings and errors during test
config :logger, level: :warn
