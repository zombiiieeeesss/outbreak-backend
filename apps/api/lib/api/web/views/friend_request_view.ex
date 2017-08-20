defmodule API.Web.FriendRequestView do
  use API.Web, :view

  alias API.Web.UserView

  def render("create.json", %{friend_request: friend_request}) do
    render_friend_request(friend_request)
  end

  def render("index.json", %{friend_requests: friend_requests}) do
    Enum.map(friend_requests, &render_friend_request/1)
  end

  defp render_friend_request(friend_request) do
    %{
      id: friend_request.id,
      status: friend_request.status,
      friend: UserView.render_user(friend_request.friend),
      requesting_user_id: friend_request.requesting_user_id
    }
  end
end
