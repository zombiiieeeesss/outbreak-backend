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
        status: "pending",
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
      query = Job.where(execute_at < time and status != "failed")
      Amnesia.Selection.values(query)
    end
  end

  @doc """
  Sets the status of the given Job to "failed". Failed jobs
  do not get re-run, but are saved for later so that they
  can be introspected.
  """
  def set_failed(job) do
    Amnesia.transaction do
      %Job{job | status: "failed"} |> Job.write
    end
  end

  @doc """
  Gets all the failed Jobs.
  """
  def get_failed_jobs do
    Amnesia.transaction do
      query = Job.where(status == "failed")
      Amnesia.Selection.values(query)
    end
  end

  @doc """
  """
  def clear_failed_jobs do
    Amnesia.transaction do
      query = Job.where(status == "failed")
      query
      |> Amnesia.Selection.values
      |> Enum.each(fn job -> Job.delete(job) end)
    end
  end
end