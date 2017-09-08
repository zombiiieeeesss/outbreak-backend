defmodule Scheduler.Job.ProducerConsumer  do
  use GenStage

  require Integer

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [Scheduler.Job.Producer]}
  end

  def handle_events(jobs, _from, state) do
    numbers =
      jobs
      |> Enum.filter(&Integer.is_even/1)

    {:noreply, numbers, state}
  end
end
