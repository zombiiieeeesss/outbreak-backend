defmodule API.Web.FriendshipView do
  use API.Web, :view

  def render("create.json", friendship), do: render_friendship(friendship)

  defp render_friendship(friendship) do
    %{id: friendship.id}
  end
end
