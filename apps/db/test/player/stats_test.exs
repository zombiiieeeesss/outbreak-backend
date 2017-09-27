defmodule DB.Player.StatsTest do
  use DB.ModelCase

  describe "#changeset" do
    test "with valid params" do
      changeset = DB.Player.Stats.changeset(%DB.Player.Stats{}, %{distance: 100})
      assert is_valid(changeset)
    end
  end
end
