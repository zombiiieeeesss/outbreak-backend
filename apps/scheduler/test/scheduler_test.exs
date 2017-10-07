defmodule Scheduler.SchedulerTest do
  use ExUnit.Case, async: true

  @fetch_interval 1

  setup _tags do
    Amnesia.Table.clear(Database.Job)
    Application.put_env(:scheduler, :fetch_interval, @fetch_interval)
    on_exit fn ->
      Scheduler.Counter.clear()
      Amnesia.Table.clear(Database.Job)
    end
  end

  describe "when jobs succeed" do
    test "the scheduler executes jobs in the fetch_interval only once" do
      Scheduler.Job.create("name", :erlang.system_time(:second), {Scheduler.Counter, :delay_increment, [@fetch_interval]})
      Scheduler.Job.create("name", :erlang.system_time(:second) + @fetch_interval, {Scheduler.Counter, :delay_increment, [@fetch_interval]})
      assert Scheduler.TimingFunctions.wait_for_execution(1)
      assert Scheduler.Counter.get == 1
      assert Scheduler.TimingFunctions.wait_for_execution(0)
      assert Scheduler.Counter.get == 2
    end
  end

  describe "when jobs fail" do
    test "the job status gets updated" do
      job = Scheduler.Job.create("name", :erlang.system_time(:second), {Scheduler.Counter, :delay_increment, [0, 1, false]})
      assert Scheduler.TimingFunctions.wait_for_execution(0)
      assert Scheduler.Counter.get == 0
      [failed_job] = Scheduler.Job.get_failed_jobs()
      assert failed_job.status == "failed"
      assert failed_job.id == job.id
    end
  end
end
