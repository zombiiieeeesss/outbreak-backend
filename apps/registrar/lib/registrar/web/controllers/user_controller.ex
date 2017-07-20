defmodule Registrar.Web.UserController do
  use Registrar.Web, :controller

  def create(conn, params) do
    case Registrar.User.create_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(user)
    end
  end
end
