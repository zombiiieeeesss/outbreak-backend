defmodule API.Player do
  @moduledoc """
  Context for players
  """

  def create(user_id, game_id) do
    DB.Player.create(user_id, game_id)
  end
end
