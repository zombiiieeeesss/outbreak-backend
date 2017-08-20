defmodule API.FriendRequest do
  @moduledoc """
  Context for friend requests
  """

  def create(requesting_user_id, requested_user_id) do
      case DB.FriendRequest.create(requesting_user_id, requested_user_id, "pending") do
        {:ok, friend_request} ->
          friend_request =
            friend_request
            |> DB.Repo.preload([:requesting_user, :requested_user])
            |> determine_friend_key(requesting_user_id)

          {:ok, friend_request}

        error -> error
      end
  end

  def list(user_id) do
    friend_requests =
      user_id
      |> DB.FriendRequest.list_by_user
      |> Enum.map(fn(fr) ->
        determine_friend_key(fr, user_id)
      end)

    {:ok, friend_requests}
  end

  defp determine_friend_key(fr, user_id) do
    requesting_user_id = fr.requesting_user_id
    requested_user_id = fr.requested_user_id

    case user_id do
      ^requesting_user_id ->
        Map.put(fr, :friend, fr.requested_user)

      ^requested_user_id ->
        Map.put(fr, :friend, fr.requesting_user)
    end
  end
end
