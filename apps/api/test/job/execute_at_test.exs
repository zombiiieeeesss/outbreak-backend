defmodule API.Job.ExecuteAtTest do
  use API.Web.ConnCase

  test "update_game execute_at" do
    start_time = %DateTime{
      calendar: Calendar.ISO, day: 20, hour: 18,
      microsecond: {273_806, 6}, minute: 58, month: 11, second: 19, std_offset: 0,
      time_zone: "Etc/UTC", utc_offset: 0, year: 2014, zone_abbr: "UTC"
    }

    game = API.Game.Factory.create_game(%{round_length: 1, start_time: start_time, round: 1})
    execute_at = API.Job.ExecuteAt.calculate("update_game", game)
    assert execute_at == 1_416_596_299
  end
end
