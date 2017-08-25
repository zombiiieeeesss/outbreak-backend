defmodule DB.FriendRequest.Factory do
  use ExMachina.Ecto, repo: DB.Repo

  def create_friend_request(attrs \\ %{}) do
    %{
      requesting_user_id: requesting_user_id,
      requested_user_id: requested_user_id,
      status: status
    } = build(:friend_request_params, attrs)

    requesting_user_id
    |> DB.FriendRequest.create(requested_user_id, status)
    |> elem(1)
  end

  def friend_request_params_factory do
    %{
      requesting_user_id: DB.User.Factory.create_user().id,
      requested_user_id: DB.User.Factory.create_user().id,
      status: "pending"
    }
  end
end
