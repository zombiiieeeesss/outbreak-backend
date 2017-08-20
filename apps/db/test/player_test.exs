defmodule DB.PlayerTest do
  use DB.ModelCase

  alias DB.{Player, Repo}

  describe "#create" do
    test "with valid params" do
      {:ok, game} = create_game()
      {:ok, user} = create_user()

      {:ok, player} = Player.create(user.id, game.id)
      player =
        player
        |> Repo.preload([:game, :user])

      assert player.game.id == game.id
      assert player.user.id == user.id
    end

    test "with invalid game id" do
      {:ok, user} = create_user()

      {:error, changeset} = Player.create(user.id, 3)

      assert %{errors: [game: _]} = changeset
    end

    test "with invalid user id" do
      {:error, changeset} = Player.create(2, 3)

      assert %{errors: [user: _]} = changeset
    end
  end
end
