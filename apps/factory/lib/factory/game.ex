defmodule Factory.Game do
  @app Application.get_env(:factory, :app)
  use ExMachina.Ecto, repo: @app.Repo

  def create_game(attrs \\ %{}) do
    build(:game_params, attrs)
    |> @app.Game.create
    |> elem(1)
  end

  def game_params_factory do
    %{
      title: "Obi-Wan's Game",
      status: "pending",
      round_length: 100,
      owner_id: Factory.User.create_user().id
    }
  end
end
