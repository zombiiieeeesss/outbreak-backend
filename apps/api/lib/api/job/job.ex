defmodule API.Job do
  @moduledoc """
  Interface for scheduling jobs
  """

  def schedule("game_create", params) do
    epoch =
      params.start_time
      |> API.TimeHelper.utc_to_epoch
    round_in_seconds =
      params.round_length
      |> API.TimeHelper.days_to_seconds

    Scheduler.Job.create({API.JobDefinitions, :define, ["game_create", params]}, epoch + round_in_seconds)
  end
end
