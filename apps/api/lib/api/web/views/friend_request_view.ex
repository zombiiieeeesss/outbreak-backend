defmodule API.Web.FriendRequestView do
  use API.Web, :view

  def render("create.json", friend_request), do: render_friend_request(friend_request)

  defp render_friend_request(friend_request) do
    %{id: friend_request.id}
  end
end
