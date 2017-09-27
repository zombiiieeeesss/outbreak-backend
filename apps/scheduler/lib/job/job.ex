defmodule Scheduler.Job do
  @moduledoc """
  Module defining job functions
  """
  use Database
  require Amnesia.Helper

  @doc """
  Creates a new Job. It takes a name, a time to execute (in erlang system
  time, seconds) and a tuple of {module, fun, args} that will be executed
  when the job is run.
  """
  def create(name, execute_at, mfa) do
    Amnesia.transaction do
      %Job{
        name: name,
        execute_at: execute_at,
        params: :erlang.term_to_binary(mfa),
        timestamp: :erlang.system_time(:second)
      }
      |> Job.write
    end
  end

  @doc """
  Deletes a job by its Key.
  """
  def delete(id) do
    Amnesia.transaction do
      Job.delete(id)
    end
  end

  @doc """
  Fetches jobs whose `execute_at` time is at most some time
  in the future, which is provided as the argument.
  """
  def fetch(time_into_future) do
    time = :erlang.system_time(:second) + time_into_future

    Amnesia.transaction do
      jobs = Job.where execute_at < time
      Amnesia.Selection.values(jobs)
    end
  end
end
