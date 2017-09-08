defmodule Scheduler.Job.ProducerConsumer  do
  @moduledoc """
  Responsible for transforming the jobs for the
  consumer to consume. It filters out jobs that
  already exist in the job set.
  """
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [Scheduler.Job.Producer]}
  end

  def handle_events(jobs, _from, state) do
    filtered_jobs = Enum.filter(jobs, &Scheduler.Job.Set.insert(&1))
    {:noreply, filtered_jobs, state}
  end
end
