defmodule API.Web.FriendshipController do
  use API.Web, :controller

  def create(conn, %{"requestee_id" => requestee_id}) do
    user = Guardian.Plug.current_resource(conn)

    case API.Friendship.create(user.id, requestee_id) do
      {:ok, friendship} ->
        conn
        |> put_status(201)
        |> render(friendship)

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(API.Web.ErrorView, "422.json", changeset)
    end
  end
end
