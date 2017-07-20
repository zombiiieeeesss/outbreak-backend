defmodule DB.Application do
  use Application

  def start do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(DB.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: DB.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
