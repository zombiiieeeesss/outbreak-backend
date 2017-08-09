defmodule API.Web.GameView do
  use API.Web, :view

  def render("create.json", game), do: render_game(game)

  defp render_game(game) do
    %{
      id: game.id,
      title: game.title,
      status: game.status,
      round_length: game.round_length
    }
  end
end
