defmodule API.Web.GameController do
  use API.Web, :controller
  alias Ecto.Multi

  action_fallback API.Web.FallbackController

  def index(conn, _params) do
    games =
      conn
      |> Guardian.Plug.current_resource
      |> API.Game.list

    conn
    |> put_status(:ok)
    |> render(games: games)
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

      with {:ok, result} <-
        DB.Repo.transaction(multi)
      do
        conn
        |> put_status(:created)
        |> render(%{game: result.game})
      end
  end
end
