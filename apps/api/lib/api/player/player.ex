defmodule API.Player do
  @moduledoc """
  Context for players
  """

  def create(user_id, game_id) do
    case DB.Player.create(%{
      user_id: user_id,
      game_id: game_id,
      status: "user-pending"
    }) do
      {:ok, player} ->
        player =
          player
          |> DB.Repo.preload(:user)
        {:ok, player}
      error -> error
    end
  end
end
