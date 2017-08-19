defmodule API.FriendRequest do
  @moduledoc """
  Context for friend requests
  """

  def create(requesting_user_id, requested_user_id) do
    DB.FriendRequest.create(requesting_user_id, requested_user_id, "pending")
  end
end
