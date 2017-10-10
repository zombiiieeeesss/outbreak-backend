defmodule API.Job.UpdateGameTest do
  use API.Web.ConnCase

  test "updates the game round" do
    game = API.Game.Factory.create_game()
    API.Job.UpdateGame.run(game)
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
    execute_at = API.Job.UpdateGame.calculate(game)
    assert execute_at == 1_416_596_299
  end
end
