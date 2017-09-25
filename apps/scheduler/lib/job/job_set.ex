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

  def update(job) do
    GenServer.call(__MODULE__, {:update, job})
  end

  def delete(job) do
    GenServer.call(__MODULE__, {:delete, job})
  end
  def delete() do
    GenServer.call(__MODULE__, :delete)
  end

  defp lookup(table, job_id) do
    case :ets.lookup(table, job_id) do
      [{^job_id, job}] -> {:ok, job}

      [] -> :error
    end
  end

  def handle_call({:update, job}, _from, table) do
    :ets.insert(table, {job.id, nil})
    {:reply, true, table}
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

  def handle_call({:delete, job}, _from, table) do
    :ets.delete(table, job.id)
    {:reply, [], table}
  end
  def handle_call(:delete, _from, table) do
    :ets.match_delete(table, {:_, nil})
    {:reply, [], table}
  end
end
