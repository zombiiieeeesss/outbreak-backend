defmodule DB.FriendRequestTest do
  use DB.ModelCase

  alias DB.{FriendRequest}

  describe "#create" do
    test "with valid params" do
      {:ok, user_one} = create_user()
      {:ok, user_two} = create_user()

      {:ok, friend_request} = FriendRequest.create(user_one.id, user_two.id, "pending")

      friend_request =
        friend_request
        |> Repo.preload([:requesting_user, :requested_user])

      assert friend_request.requesting_user.id == user_one.id
      assert friend_request.requested_user.id == user_two.id
    end

    test "with invalid requester id" do
      {:ok, user} = create_user()

      {:error, changeset} = FriendRequest.create(user.id, 2 * user.id, "pending")

      refute changeset.valid?
    end

    test "with invalid requestee id" do
      {:ok, user} = create_user()

      {:error, changeset} = FriendRequest.create(2 * user.id, user.id, "pending")

      refute changeset.valid?
    end

    test "with invalid status" do
      {:ok, user} = create_user()

      {:error, changeset} = FriendRequest.create(1, user.id, "itscomplicated")

      refute changeset.valid?
    end

    test "with creating the same friend_request relationship twice is invalid" do
      {:ok, user_one} = create_user()
      {:ok, user_two} = create_user()

      {:ok, _friend_request} = FriendRequest.create(user_one.id, user_two.id, "pending")
      {:error, changeset} = FriendRequest.create(user_one.id, user_two.id, "pending")

      refute changeset.valid?
    end
  end
end
