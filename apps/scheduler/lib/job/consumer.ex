defmodule Scheduler.Job.Consumer do
  @moduledoc """
  Responsible for processing jobs.
  """
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [Scheduler.Job.ProducerConsumer]}
  end

  def send_after(job, send_after_time) do
    Process.send_after(self(), {:"$gen_cast", {:execute, job}}, send_after_time)
  end

  def handle_cast({:execute, job}, state) do
    {:noreply, [], state}
  end

  def handle_events(jobs, _from, state) do
    Enum.each(jobs, fn(job) ->
      Scheduler.Job.Consumer.send_after(job, :rand.uniform(1000))
    end)

    {:noreply, [], state}
  end
end
