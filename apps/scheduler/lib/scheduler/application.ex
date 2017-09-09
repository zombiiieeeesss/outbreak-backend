defmodule Scheduler.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Scheduler.Job.Set, []),
      worker(Scheduler.Job.Producer, []),
      worker(Scheduler.Job.ProducerConsumer, []),
      worker(Scheduler.Job.Consumer, [])
    ]

    opts = [strategy: :one_for_one, name: Scheduler.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
