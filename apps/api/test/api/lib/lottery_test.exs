defmodule API.LotteryTest do
  use API.Web.ConnCase

  describe "#select" do
    test "selects a player to become a zombie"do
      game = create_game()
      player_one = create_player(%{game_id: game.id, stats: %{distance: 1000}})
      player_two = create_player(%{game_id: game.id, stats: %{distance: 3000}})
      player = API.Lottery.select(game.id)

      assert player == player_one.id || player == player_two.id
    end
  end
end
