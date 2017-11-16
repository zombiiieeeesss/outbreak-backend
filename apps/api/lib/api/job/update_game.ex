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
      args: [game.id, game.round]
    }

    Verk.schedule(job, perform_at(game))
  end

  def perform(id, round) do
    game = DB.Game.get(id)

    if game.round == round do
      selected_player = API.Lottery.select(id)
      DB.Repo.transaction fn ->
        DB.Game.update(game, %{round: (round + 1)})
        DB.Player.update(selected_player, %{stats: %{is_human: false}})
      end
    end
  end

  def perform_at(game) do
    Timex.shift(game.start_time, days: game.round_length)
  end
end
