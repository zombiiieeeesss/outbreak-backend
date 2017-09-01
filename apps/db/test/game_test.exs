defmodule DB.GameTest do
  use DB.ModelCase

  alias DB.{Game}

  @params %{
    title: "Obi-Wan's Game",
    status: "pending",
    round_length: 100,
    owner_id: 1
  }

  describe "#create" do
    test "with valid params" do
      {:ok, game} = Game.create(@params)

      assert game.title == @params.title
      assert game.status == @params.status
      assert game.round_length == @params.round_length
      assert game.owner_id == @params.owner_id
    end

    test "with no params" do
      {:error, changeset} = Game.create(%{})
      refute is_valid(changeset)
    end

    test "with invalid status" do
      {:error, changeset} = Game.create(%{@params | status: "wrong"})
      refute is_valid(changeset)
    end

    test "without title" do
      assert {:ok, _user} = Game.create(%{@params | title: nil})
    end
  end

  describe "#list_by_user" do
    test "given a user struct, returns a list of games for that user" do
      user = create_user()
      {:ok, game} = Game.create(@params)
      create_player(%{user_id: user.id, game_id: game.id})

      assert [^game] = DB.Game.list_by_user(user)
    end
  end
end
