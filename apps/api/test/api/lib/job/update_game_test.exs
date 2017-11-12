defmodule API.Job.UpdateGameTest do
  use API.Web.ConnCase
  alias DB.{Game, Player, Repo}
  describe "#perform" do
    test "qualifying round -- updates the game and selects a zombie" do
      game = create_game()
      player_one = create_player(%{game_id: game.id, stats: %{distance: 0}})
      player_two = create_player(%{game_id: game.id, stats: %{distance: 1000}})
      API.Job.UpdateGame.perform(game.id, game.round)

      updated_game = Repo.get(Game, game.id)
      player_one = Repo.get(Player, player_one.id)
      player_two = Repo.get(Player, player_two.id)

      assert updated_game.round == game.round + 1

      refute player_one.is_human
      assert player_two.is_human
    end

    test "qualifying round -- it is idempotent" do
      game = create_game()
      player_one = create_player(%{game_id: game.id, stats: %{distance: 0}})
      player_two = create_player(%{game_id: game.id, stats: %{distance: 1000}})

      #run the job twice
      API.Job.UpdateGame.perform(game.id, game.round)
      API.Job.UpdateGame.perform(game.id, game.round)

      updated_game = Repo.get(Game, game.id)
      player_one = Repo.get(Player, player_one.id)
      player_two = Repo.get(Player, player_two.id)

      assert updated_game.round == game.round + 1

      refute player_one.is_human
      assert player_two.is_human
    end
  end

  describe "#perform_at" do
    test "calculates the execute_at time" do
      start_time = %DateTime{
        calendar: Calendar.ISO, day: 20, hour: 18,
        microsecond: {273_806, 6}, minute: 58, month: 11, second: 19, std_offset: 0,
        time_zone: "Etc/UTC", utc_offset: 0, year: 2014, zone_abbr: "UTC"
      }

      game = API.Game.Factory.create_game(%{round_length: 1, start_time: start_time, round: 1})
      perform_at = API.Job.UpdateGame.perform_at(game)
      {:ok, datetime} = DateTime.from_unix(1_416_596_299)

      assert perform_at.month == datetime.month
      assert perform_at.day == datetime.day
      assert perform_at.minute == datetime.minute
      assert perform_at.second == datetime.second
    end
  end
end
