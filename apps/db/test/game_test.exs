defmodule DB.GameTest do
  use DB.ModelCase

  alias DB.Game

  @params %{
    title: "Obi-Wan's Game",
    status: "pending",
    round_length: 100
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
end
