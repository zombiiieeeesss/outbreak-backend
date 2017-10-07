defmodule API.TimeHelperTest do
  use ExUnit.Case, async: true

  test "#utc_to_epoch" do
    epoch = %DateTime{
      calendar: Calendar.ISO, day: 20, hour: 18, microsecond: {273_806, 6},
      minute: 58, month: 11, second: 19, time_zone: "America/Montevideo",
      utc_offset: -10_800, std_offset: 3_600, year: 2014, zone_abbr: "UYST"
    }
    |> API.TimeHelper.utc_to_epoch

    assert epoch == 1_416_517_099
  end

  test "#days_to_seconds" do
    seconds = API.TimeHelper.days_to_seconds(1)
    assert seconds == 86_400
  end
end
