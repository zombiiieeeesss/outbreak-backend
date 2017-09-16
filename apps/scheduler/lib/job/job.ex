defmodule Scheduler.Job do
  @moduledoc """
  Module defining job functions
  """
  use Database
  require Amnesia.Helper

  def create(name, execute_at, params) do
    Amnesia.transaction do
      %Job{
        name: name,
        execute_at: execute_at,
        params: params,
        timestamp: :erlang.system_time(:second)
      }
      |> Job.write
    end
  end

  def delete(id) do
    Amnesia.transaction do
      Job.delete(id)
    end
  end

  def fetch(time_into_future) do
    time = :erlang.system_time(:second) + time_into_future

    Amnesia.transaction do
      jobs = Job.where execute_at < time
      Amnesia.Selection.values(jobs)
    end
  end
end
