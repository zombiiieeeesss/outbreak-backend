use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :registrar, Registrar.Web.Endpoint,
  http: [port: 4001],
  server: false

config :guardian, Guardian,
 issuer: "Registrar",
 ttl: { 30, :days },
 allowed_drift: 2000,
 secret_key: "cHvvEICoN0azBi61y6np0nC35e9cObFsH3Yio6LbEtFkwCG7qzqo/qFtVJ+TLTsA",
 serializer: Registrar.GuardianSerializer

# Print only warnings and errors during test
config :logger, level: :warn

# Reduce complexity of encryption in tests, speeding them up
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1
