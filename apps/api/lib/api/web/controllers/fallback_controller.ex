defmodule API.Web.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}), do: render_changeset_errors(conn, changeset)
  def call(conn, {:error, _, %Ecto.Changeset{} = changeset, _}), do: render_changeset_errors(conn, changeset)
  def call(conn, {:error, status, errors}), do: render_errors(conn, status, errors)

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

  defp render_errors(conn, status, errors) do
    conn
    |> put_status(status)
    |> render(API.Web.ErrorView, "error.json", %{errors: errors})
  end
end
