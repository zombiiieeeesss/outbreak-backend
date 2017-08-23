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
      |> render(friend_request)
    end
  end
end
