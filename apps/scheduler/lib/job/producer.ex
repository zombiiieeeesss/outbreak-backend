defmodule Scheduler.Job.Producer do
  @moduledoc """
  Responsible for fetching jobs from mnesia
  and passing to the producer-consumer.
  """
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    :timer.apply_interval(60 * 100, __MODULE__, :fetch_jobs, [])
    {:producer, []}
  end

  def fetch_jobs do
    GenServer.cast(__MODULE__, :fetch_jobs)
  end

  def handle_cast(:fetch_jobs, state) do
    jobs = Scheduler.Job.fetch(60)
    {:noreply, [], Enum.uniq(state ++ jobs)}
  end

  def handle_demand(demand, state) do
    {jobs, state} = Enum.split(state, demand)
    {:noreply, jobs, state}
  end
end
