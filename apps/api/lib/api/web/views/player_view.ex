defmodule API.Web.PlayerView do
  use API.Web, :view

  def render("create.json", %{player: player}), do: render_player(player)

  defp render_player(player) do
    %{
      id: player.id,
      game_id: player.game_id,
      user_id: player.user_id
    }
  end
end
