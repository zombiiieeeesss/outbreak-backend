defmodule API.Job.ExecuteAt do
  @moduledoc """
  Module responsible for calculating job execute_at times
  """

  def calculate("update_game", params) do
    epoch =
      params.start_time
      |> API.TimeHelper.utc_to_epoch
    round_in_seconds =
      params.round_length
      |> API.TimeHelper.days_to_seconds

    epoch + (params.round * round_in_seconds)
  end
end
