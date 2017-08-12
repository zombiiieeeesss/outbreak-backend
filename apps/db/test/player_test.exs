defmodule DB.PlayerTest do
  use DB.ModelCase

  alias DB.{Game, Player, Repo, User}

  @game_params %{
    title: "Obi-Wan's Game",
    status: "pending",
    round_length: 100
  }

  @user_params %{
    username: "Obi-Wan",
    email: "obi-wan@jedicouncil.org",
    password: "ihavethehighground"
  }

  describe "#create" do
    test "with valid params" do
      {:ok, game} = Game.create(@game_params)
      {:ok, user} = User.create(@user_params)

      {:ok, player} = Player.create(user.id, game.id)
      player =
        player
        |> Repo.preload([:game, :user])

      assert player.game.id == game.id
      assert player.user.id == user.id
    end

    test "with invalid game id" do
      {:ok, user} = User.create(@user_params)

      {:error, changeset} = Player.create(user.id, 3)

      assert %{errors: [game: _]} = changeset
    end

    test "with invalid user id" do
      {:error, changeset} = Player.create(2, 3)

      assert %{errors: [user: _]} = changeset
    end
  end
end
