defmodule Scheduler.Job.Set do
  @moduledoc """
  A set ETS that stores jobs
  """
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    table = :ets.new(:job_set, [:named_table, :set, :protected, read_concurrency: true])
    {:ok, table}
  end

  def insert(job) do
    GenServer.call(__MODULE__, {:insert, job})
  end

  defp lookup(table, job_id) do
    case :ets.lookup(table, job_id) do
      [{^job_id, job}] -> {:ok, job}

      [] -> :error
    end
  end

  def handle_call({:insert, job}, _from, table) do
    case lookup(table, job.id) do
      {:ok, _job} ->
        {:reply, false, table}
      :error ->
        :ets.insert(table, {job.id, job})
        {:reply, true, table}
    end
  end
end
