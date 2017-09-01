defmodule API.Web.PlayerView do
  use API.Web, :view

  def render("create.json", %{player: player}), do: render_player(player)

  defp render_player(player) do
    %{
      id: player.id,
      game_id: player.game_id,
      user: API.Web.UserView.render_user(player.user),
      status: player.status,
    }
  end
end
