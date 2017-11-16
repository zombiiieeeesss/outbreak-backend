defmodule API.Player do
  @moduledoc """
  Context for players
  """

  def create(user_id, game_id) do
    attrs = player_create_attrs(user_id, game_id)

    case DB.Player.create(attrs) do
      {:ok, player} ->
        player =
          player
          |> DB.Repo.preload(:user)

        {:ok, player}

      error -> error
    end
  end

  def update(player_id, attrs) do
    case DB.Player.update(player_id, attrs) do
      {:ok, player} ->
        player =
          player
          |> DB.Repo.preload(:user)

        {:ok, player}

      error -> error
    end
  end

  def bulk_create(user_ids, game_id) do
    players =
      user_ids
      |> Enum.map(fn(user_id) -> player_create_attrs(user_id, game_id) end)
      |> DB.Player.bulk_create

    case players do
      {:ok, players} ->
        players = Enum.map(players, fn({_k, player}) ->
          DB.Repo.preload(player, :user)
        end)

        {:ok, players}

      error -> error
    end
  end

  def delete(player_id) do
    DB.Player.delete(player_id)
  end

  defp player_create_attrs(user_id, game_id) do
    %{
      user_id: user_id,
      game_id: game_id,
      status: "user-pending"
    }
  end
end
