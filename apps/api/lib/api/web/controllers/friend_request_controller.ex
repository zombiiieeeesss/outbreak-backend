defmodule API.Web.FriendRequestController do
  use API.Web, :controller

  action_fallback API.Web.FallbackController

  def create(conn, %{"requested_user_id" => requested_user_id}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, friend_request} <-
      API.FriendRequest.create(user.id, requested_user_id)
    do
      conn
      |> put_status(201)
      |> render("friend_request.json", %{friend_request: friend_request})
    end
  end

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    friend_requests = API.FriendRequest.list(user.id)

    conn
    |> put_status(200)
    |> render(%{friend_requests: friend_requests})
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _} <-
      API.FriendRequest.delete(id)
    do
      conn
      |> put_status(204)
      |> json("")
    end
  end

  def update(conn, %{"id" => fr_id, "status" => status}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, friend_request} <-
      API.FriendRequest.update(user.id, fr_id, %{status: status})
    do
      conn
      |> put_status(201)
      |> render("friend_request.json", %{friend_request: friend_request})
    end
  end
end
