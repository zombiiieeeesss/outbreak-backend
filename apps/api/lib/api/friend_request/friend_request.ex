defmodule API.FriendRequest do
  @moduledoc """
  Context for friend requests
  """

  def create(requester_id, requestee_id) do
    DB.FriendRequest.create(requester_id, requestee_id, "pending")
  end
end
