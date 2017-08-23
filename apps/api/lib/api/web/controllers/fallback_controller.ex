defmodule API.Web.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}), do: render_changeset_errors(conn, changeset)
  def call(conn, {:error, _, %Ecto.Changeset{} = changeset, _}), do: render_changeset_errors(conn, changeset)

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(API.Web.ErrorView, "401.json")
  end

  defp render_changeset_errors(conn, changeset) do
    conn
    |> put_status(422)
    |> render(API.Web.ErrorView, "422.json", changeset)
  end
end
