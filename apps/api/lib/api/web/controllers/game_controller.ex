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

    with {:ok, game} <-
      game_create_transaction(multi)
    do
      conn
      |> put_status(:created)
      |> render(%{user: user, game: DB.Repo.preload(game, [:players])})
    end
  end

  defp game_create_transaction(multi) do
    with {:ok, result}   <-
      DB.Repo.transaction(multi)
    do
      case API.Job.UpdateGame.schedule(result.game) do
        {:ok, _} -> {:ok, result.game}
        _ ->
          DB.Game.delete(result.game)
          {:error, 500, ["Job could not be written"]}
      end
    end
  end
end
