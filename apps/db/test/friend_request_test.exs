defmodule DB.FriendRequestTest do
  use DB.ModelCase

  alias DB.{FriendRequest}

  setup do
    user_one = create_user()
    user_two = create_user()

    {:ok, %{user_one: user_one, user_two: user_two}}
  end

  describe "#create" do
    test "with valid params", %{user_one: user_one, user_two: user_two} do
      {:ok, friend_request} = FriendRequest.create(user_one.id, user_two.id, "pending")

      friend_request =
        friend_request
        |> Repo.preload([:requesting_user, :requested_user])

      assert friend_request.requesting_user.id == user_one.id
      assert friend_request.requested_user.id == user_two.id
    end

    test "with invalid requester id", %{user_one: user} do
      {:error, changeset} = FriendRequest.create(user.id, 0, "pending")

      refute changeset.valid?
    end

    test "with invalid requestee id", %{user_one: user} do
      {:error, changeset} = FriendRequest.create(0, user.id, "pending")

      refute changeset.valid?
    end

    test "with invalid status", %{user_one: user} do
      {:error, changeset} = FriendRequest.create(1, user.id, "itscomplicated")

      refute changeset.valid?
    end

    test "with creating the same friend_request relationship twice is invalid", %{user_one: user_one, user_two: user_two} do
      {:ok, _friend_request} = FriendRequest.create(user_one.id, user_two.id, "pending")
      {:error, changeset} = FriendRequest.create(user_one.id, user_two.id, "pending")
      {:error, _changeset} = FriendRequest.create(user_two.id, user_one.id, "pending")

      refute changeset.valid?
    end

    test "with the same id for requesting and requested returns and error",
      %{user_one: user} do
        msg = ["Users cannot request themselves"]
        {:error, 400, ^msg} = FriendRequest.create(user.id, user.id)
    end
  end

  describe "#list_by_user" do
    test "with valid params", %{user_one: user_one} do
      create_friend_request(%{requesting_user_id: user_one.id})
      create_friend_request(%{requesting_user_id: user_one.id})
      create_friend_request(%{requesting_user_id: user_one.id})

      frs = FriendRequest.list_by_user(user_one.id)
      assert length(frs) == 3
    end
  end

  describe "#delete" do
    test "with valid params", %{user_one: user_one} do
      fr = create_friend_request(%{requesting_user_id: user_one.id})

      assert {:ok, _} = FriendRequest.delete(fr.id)
    end

    test "when the friend request does not exist" do
      assert {:error, _, _} = FriendRequest.delete(0)
    end
  end
end
