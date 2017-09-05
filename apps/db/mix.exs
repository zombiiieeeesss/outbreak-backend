defmodule Db.Mixfile do
  use Mix.Project

  def project do
    [app: :db,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [extra_applications: [:logger, :postgrex, :ecto, :comeonin, :factory],
     mod: {DB.Application, []}]
  end

  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:factory, in_umbrella: true, only: :test},
      {:faker_elixir_octopus, "~> 1.0.0", only: :dev},
      {:postgrex, "~> 0.13.3"},
      {:comeonin, "~> 3.2"},
    ]
  end
end
