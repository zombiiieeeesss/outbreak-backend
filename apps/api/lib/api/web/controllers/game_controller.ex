defmodule API.Web.GameController do
  use API.Web, :controller
  alias Ecto.Multi

  action_fallback API.Web.FallbackController

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    games =
      user
      |> API.Game.list
      |> Enum.map(fn game ->
        DB.Repo.preload(game, :players)
      end)

    conn
    |> put_status(:ok)
    |> render(%{user: user, games: games})
  end

  def create(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    multi =
      Multi.new
      |> Multi.run(:game, fn(_) ->
        params
        |> Map.put("owner_id", user.id)
        |> API.Game.create
      end)
      |> Multi.run(:player, fn(%{game: game}) ->
        API.Player.create(user.id, game.id)
      end)

      with {:ok, result} <- DB.Repo.transaction(multi),
        API.Job.UpdateGame.schedule(result.game)
      do
        game = DB.Repo.preload(result.game, [:players])
        conn
        |> put_status(:created)
        |> render(%{user: user, game: game})
      end
  end
end
