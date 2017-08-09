defmodule API.Web.GameController do
  use API.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def create(conn, params) do
    case API.Game.create(params) do
      {:ok, game} ->
        conn
        |> put_status(:created)
        |> render(game)

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(API.Web.ErrorView, "422.json", changeset)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(API.Web.ErrorView, "401.json")
  end
end
