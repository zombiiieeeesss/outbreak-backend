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
      |> render(%{friend_request: friend_request})
    end
  end

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, friend_requests} <-
      API.FriendRequest.list(user.id)
    do
      conn
      |> put_status(200)
      |> render(%{friend_requests: friend_requests})
    end
  end
end
