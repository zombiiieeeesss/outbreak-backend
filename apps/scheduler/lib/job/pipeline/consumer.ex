defmodule Scheduler.Job.Consumer do
  @moduledoc """
  Responsible for processing jobs.
  """
  use GenStage
  require Logger

  def start_link do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [Scheduler.Job.ProducerConsumer]}
  end

  def handle_events(jobs, _from, state) do
    Enum.each(jobs, fn(job) ->
      execute_job(job)
    end)

    {:noreply, [], state}
  end

  defp execute_job(job) do
    {m, f, a} = :erlang.binary_to_term(job.params)
    Logger.info("Executing #{m}")
    with :ok <- Kernel.apply(m, f, a),
         :ok <- Scheduler.Job.delete(job.id)
    do
      Scheduler.Job.Set.update(job)
    else
      _ ->
        Logger.error("Job #{job.id} failed.")
        Scheduler.Job.Set.delete(job)
        Scheduler.Job.set_failed(job)
    end
  end
end
