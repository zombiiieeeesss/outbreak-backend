defmodule API.Player.Factory do
  use ExMachina.Ecto, repo: DB.Repo

  def create_player(attrs \\ %{}) do
    build(:player_params, attrs)
    |> DB.Player.create
    |> elem(1)
  end

  def player_params_factory do
    %{
      user_id: DB.User.Factory.create_user().id,
      game_id: DB.Game.Factory.create_game().id,
      is_human: true,
      status: "user-pending"
    }
  end
end
