defmodule API.Web.GameView do
  use API.Web, :view

  def render("index.json", %{user: user, games: games}) do
    Enum.map(games, &(render_game(user, &1)))
  end

  def render("create.json", %{user: user, game: game}) do
    render_game(user, game)
  end

  defp render_game(user, game) do
    %{
      id: game.id,
      owner_id: game.owner_id,
      title: game.title,
      status: game.status,
      round: game.round,
      round_length: game.round_length,
      round_limit: game.round_limit,
      start_time: game.start_time,
      player: get_player_info(user, game)
    }
  end

  defp get_player_info(user, game) do
    case find_player(user, game) do
       %DB.Player{} = player ->
        %{id: player.id, status: player.status}
      _ ->
        %{}
    end
  end

  defp find_player(user, game) do
    Enum.find(game.players, fn player ->
      player.user_id == user.id
    end)
  end
end
