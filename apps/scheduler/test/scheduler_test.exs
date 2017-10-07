defmodule Scheduler.SchedulerTest do
  use ExUnit.Case, async: true

  setup _tags do
    Application.put_env(:scheduler, :fetch_interval, 0)
    Scheduler.Job.create("name", :erlang.system_time(:second), {Scheduler.TestJob, :test_function, []})
    on_exit fn ->
      Amnesia.Table.clear(Database.Job)
    end
  end

  test "the scheduler executes jobs in the fetch_interval" do
    :timer.sleep(10000)
  end
end
