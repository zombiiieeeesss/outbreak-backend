defmodule API.Friendship do
  @moduledoc """
  Context for friendships
  """

  def create(requester_id, requestee_id) do
    DB.Friendship.create(requester_id, requestee_id, "pending")
  end
end
