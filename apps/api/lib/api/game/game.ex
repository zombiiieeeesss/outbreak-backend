defmodule API.Game do
  @moduledoc """
  Context for games
  """
  def list(user) do
    DB.Game.list_by_user(user)
  end

  def create(attrs) do
    attrs
    |> Map.put("status", "qualifying")
    |> DB.Game.create
  end

  def verify_owner(game_id, user_id) do
    game = DB.Game.get(game_id)

    case game.owner_id do
      ^user_id -> :ok
      _ -> {:error, 401, ["User does not own game"]}
    end
  end
end
