defmodule DB.PlayerTest do
  use DB.ModelCase

  alias DB.{Player, Repo}

  setup do
    user = create_user()
    game = create_game()

    {:ok, %{user: user, game: game}}
  end

  describe "#create" do
    test "with valid params", %{user: user, game: game} do
      {:ok, player} = Player.create(%{user_id: user.id, game_id: game.id, status: "user-pending"})
      player =
        player
        |> Repo.preload([:game, :user])

      assert player.game.id == game.id
      assert player.user.id == user.id
    end

    test "with invalid game id", %{user: user} do
      {:error, changeset} = Player.create(%{user_id: user.id, game_id: 3, status: "user-pending"})

      assert %{errors: [game: _]} = changeset
    end

    test "with invalid user id", %{game: game} do
      {:error, changeset} = Player.create(%{user_id: 2, game_id: game.id, status: "user-pending"})

      assert %{errors: [user: _]} = changeset
    end

    test "with invalid status", %{user: user, game: game} do
      {:error, changeset} = Player.create(%{user_id: user.id, game_id: game.id, status: "pending"})

      assert %{errors: [status: _]} = changeset
    end
  end
end
