defmodule API.Web.FriendshipController do
  use API.Web, :controller

  action_fallback API.Web.FallbackController

  def create(conn, %{"requestee_id" => requestee_id}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, friendship} <-
      API.Friendship.create(user.id, requestee_id)
    do
      conn
      |> put_status(201)
      |> render(friendship)
    end
  end
end
