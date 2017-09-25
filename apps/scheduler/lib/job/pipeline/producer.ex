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
    :timer.apply_interval(fetch_interval() * 100, __MODULE__, :cast_fetch_jobs, [])
    {:producer, {fetch_jobs(), 0}}
  end

  def cast_fetch_jobs do
    GenServer.cast(__MODULE__, :fetch_jobs)
  end

  def handle_cast(:fetch_jobs, {pending_jobs, pending_demand}) do
    dispatch_events(pending_jobs ++ fetch_jobs(), pending_demand)
  end

  def handle_demand(demand, {pending_jobs, _pending_demand}) do
    dispatch_events(pending_jobs, demand)
  end

  defp dispatch_events(jobs, demand) do
    {events, pending_jobs} = Enum.split(jobs, demand)
    demand = demand - length(events)

    {:noreply, events, {pending_jobs, demand}}
  end

  defp fetch_jobs, do: fetch_interval() |> Scheduler.Job.fetch

  defp fetch_interval, do: Application.get_env(:scheduler, :fetch_interval)
end
