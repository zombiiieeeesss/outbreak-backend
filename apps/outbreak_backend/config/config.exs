use Mix.Config

config :outbreak_backend, ecto_repos: [OutbreakBackend.Repo]

import_config "#{Mix.env}.exs"
