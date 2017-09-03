defmodule API.Web.PlayerView do
  use API.Web, :view

  def render("create.json", %{players: players}), do: Enum.map(players, &render_player/1)

  defp render_player(player) do
    %{
      id: player.id,
      game_id: player.game_id,
      user: API.Web.UserView.render_user(player.user),
      status: player.status,
    }
  end
end
