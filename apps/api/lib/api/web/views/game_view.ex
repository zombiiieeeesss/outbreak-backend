defmodule API.Web.GameView do
  use API.Web, :view

  def render("index.json", %{games: games}) do
    Enum.map(games, &render_game/1)
  end

  def render("create.json", %{game: game}), do: render_game(game)

  defp render_game(game) do
    %{
      id: game.id,
      owner_id: game.owner_id,
      title: game.title,
      status: game.status,
      round_length: game.round_length
    }
  end
end
