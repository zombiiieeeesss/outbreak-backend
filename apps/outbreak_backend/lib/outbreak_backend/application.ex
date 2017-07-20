defmodule OutbreakBackend.Application do
  @moduledoc """
  The OutbreakBackend Application Service.

  The outbreak_backend system business domain lives in this application.

  Exposes API to clients such as the `OutbreakBackend.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(OutbreakBackend.Repo, []),
    ], strategy: :one_for_one, name: OutbreakBackend.Supervisor)
  end
end
