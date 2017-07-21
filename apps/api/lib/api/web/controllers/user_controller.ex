defmodule API.Web.UserController do
  use API.Web, :controller

  def create(conn, params) do
    case API.User.create(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(user)

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> json(changeset.errors)
    end
  end

  def login(conn, params) do
    case API.User.login(params) do
      {:ok, user, jwt, exp} ->
        conn
        |> put_status(201)
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", Integer.to_string(exp))
        |> render("login.json", %{user: user, jwt: jwt})

      {:error, _} -> send_resp(conn, 401, "Unauthorized")
    end
  end

  def refresh(conn, params) do
    token = conn.req_headers
      |> Enum.into(%{})
      |> Map.get("authorization")
    case Guardian.refresh!(token) do
      {:ok, jwt, %{"exp" => exp}} ->
          conn
          |> put_status(201)
          |> put_resp_header("authorization", "Bearer #{jwt}")
          |> put_resp_header("x-expires", Integer.to_string(exp))
          |> json(%{jwt: jwt})
      {:error, _} -> send_resp(conn, 401, "Unauthorized")
    end
  end
end
