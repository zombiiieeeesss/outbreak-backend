defmodule DB.GameTest do
  use DB.ModelCase

  alias DB.{User, Game, Player}

  @params %{
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
      {:ok, game} = Game.create(@params)

      assert game.title == @params.title
      assert game.status == @params.status
      assert game.round_length == @params.round_length
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
      {:ok, game} = Game.create(@params)
      {:ok, user} = User.create(@user_params)
      {:ok, _player} = Player.create(user.id, game.id)

      assert [^game] = DB.Game.list_by_user(user)
    end
  end
end
