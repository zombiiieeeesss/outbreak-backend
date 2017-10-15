defmodule API.Job.UpdateGame do
  @moduledoc """
  This module is responsible for carrying out a job to update the
  game status.
  """
  require Logger

  def schedule(game) do
    job = %Verk.Job{
      queue: :default,
      class: __MODULE__,
      args: [game.id, %{round: game.round + 1}]
    }

    Verk.schedule(job, perform_at(game))
  end

  def perform(id, attrs) do
    id
    |> DB.Game.get
    |> DB.Game.update(attrs)
  end

  def perform_at(game) do
    Timex.shift(game.start_time, days: game.round_length)
  end
end
