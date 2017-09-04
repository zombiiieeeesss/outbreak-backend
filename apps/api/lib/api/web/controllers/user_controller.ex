defmodule API.Web.UserController do
  use API.Web, :controller

  action_fallback API.Web.FallbackController

  def search(conn, %{"q" => query}) do
    current_user = Guardian.Plug.current_resource(conn)
    users = API.User.search_users(query, except: current_user.id)

    conn
    |> put_status(:ok)
    |> render(%{users: users})
  end

  def search(conn, _params) do
    msg = "Missing or invalid search query parameter."
    conn
    |> put_status(:bad_request)
    |> json(%{errors: [msg]})
  end

  def create(conn, params) do
    with {:ok, user} <-
      API.User.create(params)
    do
      conn
      |> put_status(201)
      |> render(user)
    end
  end

  def login(conn, params) do
    with {:ok, user, token, exp} <-
      API.User.login(params)
    do
      conn
      |> put_status(201)
      |> authorization_headers(token, exp)
      |> render(%{user: user, token: token, exp: exp})
    end
  end

  def refresh(conn, _params) do
    token = Guardian.Plug.current_token(conn)
    case Guardian.refresh!(token) do
      {:ok, token, %{"exp" => exp}} ->
        conn
        |> put_status(201)
        |> authorization_headers(token, exp)
        |> render(%{token: token, exp: exp})

      {:error, _} ->
        conn
        |> put_status(401)
        |> json(%{errors: ["Invalid Token"]})
    end
  end

  defp authorization_headers(conn, token, exp) do
    conn
    |> put_resp_header("authorization", token)
    |> put_resp_header("x-expires", Integer.to_string(exp))
  end
end
