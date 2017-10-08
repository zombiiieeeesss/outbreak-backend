defmodule Scheduler.TimingFunctions do
  def wait_for_execution(job_count) do
    case Scheduler.Job.job_count - length(Scheduler.Job.get_failed_jobs) do
      ^job_count -> true
      _ -> wait_for_execution(job_count)
    end
  end
end
