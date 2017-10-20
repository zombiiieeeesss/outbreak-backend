defmodule API.Job.UpdateGameTest do
  use API.Web.ConnCase

  test "updates the game round" do
    game = API.Game.Factory.create_game()
    API.Job.UpdateGame.perform(game.id, %{round: game.round + 1})
    updated_game = DB.Game.get(game.id)
    assert updated_game.round == game.round + 1
  end

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
