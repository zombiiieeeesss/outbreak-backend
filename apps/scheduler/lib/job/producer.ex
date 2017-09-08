defmodule Scheduler.Job.Producer do
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    jobs = Enum.to_list(state..state + demand - 1)
    {:noreply, jobs, (state + demand)}
  end
end
