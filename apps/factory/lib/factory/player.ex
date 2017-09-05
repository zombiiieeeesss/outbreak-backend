defmodule Factory.Player do
  @app Application.get_env(:factory, :app)
  use ExMachina.Ecto, repo: @app.Repo

  def create_player(attrs \\ %{}) do
    build(:player_params, attrs)
    |> @app.Player.create
    |> elem(1)
  end

  def player_params_factory do
    %{
      user_id: Factory.User.create_user().id,
      game_id: Factory.Game.create_game().id,
      status: "user-pending"
    }
  end
end
