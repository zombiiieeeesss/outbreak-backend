defmodule API.LotteryTest do
  use API.Web.ConnCase

  describe "#select/2" do
    test "qualifying round -- selects a player when both have distance"do
      game = create_game()
      player_one = create_player(%{game_id: game.id, stats: %{distance: 1000}})
      player_two = create_player(%{game_id: game.id, stats: %{distance: 3000}})
      player = API.Lottery.select(game.id, 1)

      assert player == player_one.id || player == player_two.id
    end

    test "qualifying round -- selects a player when one has distance" do
      game = create_game()
      create_player(%{game_id: game.id, stats: %{distance: 1000}})
      player_two = create_player(%{game_id: game.id, stats: %{distance: 0}})
      player = API.Lottery.select(game.id, 1)

      assert player == player_two.id
    end

    test "subsequent rounds -- selects a player when not safe" do
      game = create_game()
      create_player(%{game_id: game.id, stats: %{is_human: false, distance: 1000}})
      player_two = create_player(%{game_id: game.id, stats: %{distance: 10}})
      selection = API.Lottery.select(game.id, 2)

      assert selection == player_two.id
    end

    test "subsequent rounds -- does not select a safe player" do
      game = create_game()
      create_player(%{game_id: game.id, stats: %{is_human: false, distance: 100}})
      create_player(%{game_id: game.id, stats: %{distance: 1000}})
      selection = API.Lottery.select(game.id, 2)

      assert selection == :safe
    end
  end
end
