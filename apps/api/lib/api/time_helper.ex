defmodule API.TimeHelper do
  @moduledoc """
  Module dealing with time
  """
  def utc_to_epoch(time) do
    DateTime.to_unix(time)
  end

  def days_to_seconds(days) do
    days
    |> days_to_hours
    |> hours_to_minutes
    |> minutes_to_seconds
  end

  defp days_to_hours(days), do: days * 24

  defp hours_to_minutes(hours), do: hours * 60

  defp minutes_to_seconds(minutes), do: minutes * 60
end
