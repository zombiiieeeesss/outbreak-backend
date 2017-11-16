defmodule API.Game.Factory do
  use ExMachina.Ecto, repo: DB.Repo

  def create_game(attrs \\ %{}) do
    build(:game_params, attrs)
    |> DB.Game.create
    |> elem(1)
  end

  def game_params_factory do
    %{
      title: "Obi-Wan's Game",
      status: "qualifying",
      round_length: 100,
      round_limit: 5,
      owner_id: API.User.Factory.create_user().id,
      start_time: DateTime.utc_now()
    }
  end
end
