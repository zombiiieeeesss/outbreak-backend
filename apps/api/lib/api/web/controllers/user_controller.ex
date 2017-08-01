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
        |> render(API.Web.ErrorView, "422.json", changeset)
    end
  end

  def login(conn, params) do
    case API.User.login(params) do
      {:ok, user, token, exp} ->
        conn
        |> put_status(201)
        |> authorization_headers(token, exp)
        |> render(%{user: user, token: token, exp: exp})

      {:error, _} -> send_resp(conn, 401, "Unauthorized")
    end
  end

  def refresh(conn, _params) do
    token = get_token(conn)
    case Guardian.refresh!(token) do
      {:ok, token, %{"exp" => exp}} ->
        conn
        |> put_status(201)
        |> authorization_headers(token, exp)
        |> render(%{token: token, exp: exp})

      {:error, _} -> send_resp(conn, 401, "Unauthorized")
    end
  end

  defp authorization_headers(conn, token, exp) do
    conn
    |> put_resp_header("authorization", token)
    |> put_resp_header("x-expires", Integer.to_string(exp))
  end

  defp get_token(conn) do
    conn.req_headers
    |> Enum.into(%{})
    |> Map.get("authorization")
  end
end
