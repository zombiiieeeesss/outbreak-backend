defmodule API.Job do
  @moduledoc """
  Interface for scheduling jobs
  """

  def schedule(name, params) do
    execute_at = API.Job.ExecuteAt.calculate(name, params)
    Scheduler.Job.create({API.Job.Definitions, :run, ["#{name}", params]}, execute_at)
  end
end
