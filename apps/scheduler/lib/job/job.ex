defmodule Scheduler.Job do
  @moduledoc """
  Module defining job functions
  """
  # use Database
  # require Amnesia.Helper

  @doc """
  Creates a new Job. It takes a time to execute (in erlang system
  time, seconds) and a tuple of {module, fun, args} that will be executed
  when the job is run.
  """
  def create(mfa, execute_at) do
    DB.Job.create(%{params: :erlang.term_to_binary(mfa), execute_at: execute_at, status: "pending"})
    # Amnesia.transaction do
    #   %Job{
    #     execute_at: execute_at,
    #     params: :erlang.term_to_binary(mfa),
    #     status: "pending",
    #     timestamp: :erlang.system_time(:second)
    #   }
    #   |> Job.write
    # end
  end

  @doc """
  Deletes a job by its Key.
  """
  def delete(id) do
    DB.Job.delete(id)
    :ok
    # Amnesia.transaction do
    #   Job.delete(id)
    # end
  end

  @doc """
  Fetches jobs whose `execute_at` time is at most some time
  in the future, which is provided as the argument.
  """
  def fetch(time_into_future) do
    DB.Job.fetch(time_into_future)
    # time = :erlang.system_time(:second) + time_into_future
    #
    # Amnesia.transaction do
    #   query = Job.where(execute_at < time and status != "failed")
    #   Amnesia.Selection.values(query)
    # end
  end

  @doc """
  Sets the status of the given Job to "failed". Failed jobs
  do not get re-run, but are saved for later so that they
  can be introspected.
  """
  def set_failed(job) do
    DB.Job.set_failed(job)
    # Amnesia.transaction do
    #   %Job{job | status: "failed"} |> Job.write
    # end
  end

  @doc """
  Gets all the failed Jobs.
  """
  def get_failed_jobs do
    DB.Job.get_failed_jobs()
    # Amnesia.transaction do
    #   query = Job.where(status == "failed")
    #   Amnesia.Selection.values(query)
    # end
  end

  @doc """
  """
  # def clear_failed_jobs do
  #   Amnesia.transaction do
  #     query = Job.where(status == "failed")
  #     query
  #     |> Amnesia.Selection.values
  #     |> Enum.each(fn job -> Job.delete(job) end)
  #   end
  # end
  #
  def job_count do
    DB.Job.job_count()
    # Amnesia.Table.count(Database.Job)
  end
end
