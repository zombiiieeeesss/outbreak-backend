defmodule API.Lottery do
  @moduledoc """
  This module is responsible selecting the zombies
  at the conclusion of every round.
  """
  alias DB.{Game}

  def select(game_id) do
    players = Game.get_players(game_id)
    total_steps = total_steps(players)

    players
    |> build_qualifying_pool(total_steps)
    |> Enum.random
  end

  def build_qualifying_pool(players, total_steps) do
    number_of_players = length(players)
    Enum.reduce(players, [], fn(player, acc) ->
      number_of_tickets = qualifying_calculation(player, total_steps, number_of_players)
      tickets = List.duplicate(player, number_of_tickets)
      tickets ++ acc
    end)
  end

  defp qualifying_calculation(player, total_steps, number_of_players) do
    ((1 - (player.stats.distance/total_steps)) * number_of_players)
    |> round
  end

  defp total_steps(players) do
    Enum.reduce(players, 0, fn(player, acc) ->
      acc + player.stats.distance
    end)
  end
end
