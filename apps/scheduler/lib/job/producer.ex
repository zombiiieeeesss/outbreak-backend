defmodule Scheduler.Job.Producer do
  @moduledoc """
  Responsible for fetching jobs from mnesia
  and passing to the producer-consumer.
  """
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    jobs = Enum.map(state..state + demand - 1, fn(x) -> %{id: x} end)
    {:noreply, jobs, (state + demand)}
  end
end
