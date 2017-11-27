defmodule API.Lottery do
  @moduledoc """
  This module is responsible selecting zombies at the conclusion of every round.
  """
  alias DB.{Game}

  @doc """
  Selects a player from a game for the given round.

  This consists of getting a list of players, building a pool to choose from,
  and finally selecting a player from that pool.

  ## Parameters

    game_id - An Integer representing the Game id
    round - An Integer representing the current round
  """
  def select(game_id, 1) do
    game_id
    |> Game.get_players
    |> build_qualifying_pool
    |> List.flatten
    |> Enum.random
  end
  def select(game_id, round) do
    game_id
    |> Game.get_players
    |> build_round_pool
    |> List.flatten
    |> Enum.random
  end

  # Builds the probability pool for players in a qualifying round.
  #
  # It finds the total distance of all players, calculates a probability for
  # each player based on their distance relative to the total distance in the
  # qualifying round, and adds "lottery tickets" to the pool.
  defp build_qualifying_pool(players) do
    total_distance = total_distance(players)
    number_of_players = length(players)
    Enum.reduce(players, [], fn(player, acc) ->
      number_of_tickets = qualifying_calculation(player, total_distance, number_of_players)
      tickets = List.duplicate(player.id, number_of_tickets)
      [tickets | acc]
    end)
  end

  # Builds the probability pool for players in a non-qualifying round.
  #
  # It finds the average distance of the zombie team, calculates a probability
  # for each player based on their distance relative to the zombie average, and
  # adds "lottery tickets" to the pool.
  defp build_round_pool(players) do
    zombie_avg = average_distance(players, is_human: false)
    humans = filter_players(players)
    Enum.reduce(humans, [], fn(player, acc) ->
      tickets = determine_player_tickets(player, zombie_avg)
      [tickets | acc]
    end)
  end

  # Calculates a player's number of tickets for the qualifying round.
  #
  # A player's distance is weighed against the total distance of all players
  # in the round.
  defp qualifying_calculation(player, total_distance, number_of_players) do
    round(((1 - (player.stats.distance / total_distance)) * number_of_players))
  end

  # Determines the number of tickets that a player has in the lottery.
  #
  # The methodology is as follows: A player starts with 10 tickets, and
  # is given 'safe tickets' for distance run beyond the calculated average
  # distance of the zombie team. If a player runs >= twice the amount of the
  # zombie average, they are completely safe: All 10 of their tickets are
  # added as 'safe tickets,' without the player's id on them. If the player does
  # not pass the zombie average, all tickets are returned with the player's id.
  defp determine_player_tickets(player, zombie_average) do
    starting = 10
    safe = calculate_safe_tickets(player.stats.distance,
                                  zombie_average,
                                  starting)
    safe_tickets = List.duplicate(:safe, safe)
    player_tickets = List.duplicate(player.id, starting - safe)
    Enum.concat(safe_tickets, player_tickets)
  end

  # Determines the number of "safe tickets" available to a player in a
  # non-qualifying round.
  #
  # Iff a player's distance is greater than the zombie average, they will
  # be awarded "safe tickets."
  defp calculate_safe_tickets(distance, zombie_average, starting)
    when distance > zombie_average do
      min(round(starting * ((distance / zombie_average) - 1)), starting)
  end
  defp calculate_safe_tickets(_distance, _zombie_average, _starting) do
    0
  end

  # Determines the total distance of a given List of Players.
  defp total_distance(players) do
    Enum.reduce(players, 0, fn(player, acc) ->
      acc + player.stats.distance
    end)
  end

  # Filters players by their `is_human` status.
  defp filter_players(players, [{:is_human, is_human}]) do
    Enum.filter(players, fn player ->
      player.stats.is_human == is_human
    end)
  end
  defp filter_players(players) do
    filter_players(players, is_human: true)
  end

  # Finds the average distance of a group of players, either human or zombie.
  defp average_distance(players, [{:is_human, is_human}]) do
    team = filter_players(players, is_human: is_human)
    team_distance = total_distance(team)
    team_distance / length(team)
  end
end
