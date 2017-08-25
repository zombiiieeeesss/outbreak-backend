defmodule DB.Game.Factory do
  use ExMachina.Ecto, repo: DB.Repo

  def create_game(attrs \\ %{}) do
    build(:game_params, attrs)
    |> DB.Game.create
    |> elem(1)
  end

  def game_params_factory do
    %{
      title: "Obi-Wan's Game",
      status: "pending",
      round_length: 100
    }
  end
end
