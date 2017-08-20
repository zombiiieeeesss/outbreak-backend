defmodule API.Game.Factory do
  use ExMachina.Ecto, repo: DB.Repo

  def create_game(status \\ "pending") do
    status
    |> game_params
    |> API.Game.create
  end

  defp game_params(status) do
    %{
      title: "Obi-Wan's Game",
      status: status,
      round_length: 100
    }
  end
end
