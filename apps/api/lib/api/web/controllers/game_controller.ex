defmodule API.Web.GameController do
  use API.Web, :controller
  alias Ecto.Multi

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
      |> Multi.run(:game, fn(_) -> API.Game.create(params) end)
      |> Multi.run(:player, fn(%{game: game}) ->
        API.Player.create(user.id, game.id)
      end)

    case DB.Repo.transaction(multi) do
      {:ok, result} ->
        conn
        |> put_status(:created)
        |> render(result.game)
      {:error, _, changeset, _} ->
        conn
        |> put_status(422)
        |> render(API.Web.ErrorView, "422.json", changeset)
    end
  end
end
