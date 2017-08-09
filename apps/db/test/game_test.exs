defmodule GameTest do
  use DB.ModelCase

  alias DB.Game

  @params %{
    title: "Obi-Wan's Game",
    status: "pending",
    round_length: 100
  }

  test "#create game with valid params" do
    {:ok, user} = Game.create(@params)

    assert user.title == @params.title
    assert user.status == @params.status
    assert user.round_length == @params.round_length
  end

  test "#create game with invalid params" do
    {:error, changeset} = Game.create(%{})
    refute is_valid(changeset)
  end
end
