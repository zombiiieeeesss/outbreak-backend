defmodule Scheduler.TimingFunctions do
  def wait_for_execution(job_count) do
    case Amnesia.Table.count(Database.Job) do
      ^job_count -> true
      _ -> wait_for_execution(job_count)
    end
  end
end
