defmodule API.Job.Definitions do
  @moduledoc """
  Module for defining jobs
  """

  def run("update_game", params) do
    with {:ok, updated_game} <-
      DB.Game.update(params, %{round: params.round + 1}),

      %Database.Job{} <-
        API.Job.schedule("update_game", updated_game),
    do: :ok
  end
end
