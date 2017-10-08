defmodule API.Job.DefinitionsTest do
  use API.Web.ConnCase

  test "update_game definition" do
    game = API.Game.Factory.create_game()
    API.Job.Definitions.run("update_game", game)
    updated_game = DB.Game.get(game.id)
    assert updated_game.round == game.round + 1
    assert Scheduler.Job.job_count == 1
  end
end
