defmodule API.Job.UpdateGame do
  @moduledoc """
  This module is responsible for carrying out a job to update the
  game status.
  """
  require Logger

  def schedule(game) do
    execute_at = calculate(game)
    Logger.info("Scheduling #{__MODULE__}, game: #{game.id}")
    Scheduler.Job.create({__MODULE__, :run, game}, execute_at)
  end

  def run(game) do
    with {:ok, _updated_game} <-
      DB.Game.update(game, %{round: game.round + 1}),
    do: :ok
  end

  def calculate(game) do
    epoch =
      game.start_time
      |> API.TimeHelper.utc_to_epoch
    round_in_seconds =
      game.round_length
      |> API.TimeHelper.days_to_seconds

    epoch + (game.round * round_in_seconds)
  end
end
