defmodule API.Web.PlayerController do
  use API.Web, :controller

  action_fallback API.Web.FallbackController

  def create(conn, %{"user_id" => user_id, "game_id" => game_id}) do
    user = Guardian.Plug.current_resource(conn)

      with :ok <- API.Game.verify_owner(game_id, user.id),
          {:ok, player} <- API.Player.create(user_id, game_id)
      do
        conn
        |> put_status(:created)
        |> render(%{player: player})
      end
  end
end
