defmodule Scheduler.Job do
  @moduledoc """
  Module defining job functions
  """
  use Database
  require Amnesia.Helper

  def create(name, execute_at) do
    Amnesia.transaction do
      %Job{name: name, execute_at: execute_at, timestamp: :erlang.system_time(:second)}
      |> Job.write
    end
  end

  def fetch(future_time) do
    time = :erlang.system_time(:second) + future_time

    Amnesia.transaction do
      jobs = Job.where execute_at < time
      Amnesia.Selection.values(jobs)
    end
  end
end
