# defmodule Scheduler.JobSet do
#   use GenServer
#
#   def start_link(_opts) do
#     GenServer.start_link(__MODULE__)
#   end
#
#   @doc """
#   Looks up the bucket pid for `name` stored in `server`.
#
#   Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
#   """
#   def lookup(server, job) do
#     case :ets.lookup(server, job) do
#       [{^job., pid}] -> {:ok, pid}
#       [] -> :error
#     end
#   end
#
#   @doc """
#   Ensures there is a bucket associated with the given `name` in `server`.
#   """
#   def create(server, name) do
#     GenServer.cast(server, {:create, name})
#   end
#
#   ## Server callbacks
#
#   def init do
#     # 3. We have replaced the names map by the ETS table
#     table = :ets.new(:job_set, [:named_table, read_concurrency: true])
#     {:ok, table}
#   end
#
#   # 4. The previous handle_call callback for lookup was removed
#
#   def handle_cast({:insert, job}, table) do
#     # 5. Read and write to the ETS table instead of the map
#     case lookup(table, job) do
#       {:ok, _pid} ->
#         {:noreply, {names, refs}}
#       :error ->
#         :ets.insert(names, {job.id, pid})
#         {:noreply, {names, refs}}
#     end
#   end
#
#   def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
#     # 6. Delete from the ETS table instead of the map
#     {name, refs} = Map.pop(refs, ref)
#     :ets.delete(names, name)
#     {:noreply, {names, refs}}
#   end
#
#   def handle_info(_msg, state) do
#     {:noreply, state}
#   end
# end
