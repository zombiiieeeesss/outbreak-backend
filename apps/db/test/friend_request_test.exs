defmodule DB.FriendRequestTest do
  use DB.ModelCase

  alias DB.{FriendRequest, User}

  @user_one_params %{
    username: "Obi-Wan",
    email: "obi-wan@jedicouncil.org",
    password: "ihavethehighground"
  }

  @user_two_params %{
    username: "Yoda",
    email: "yoda@jedicouncil.org",
    password: "ihavethehighground"
  }

  describe "#create" do
    test "with valid params" do
      {:ok, user_one} = User.create(@user_one_params)
      {:ok, user_two} = User.create(@user_two_params)

      {:ok, friend_request} = FriendRequest.create(user_one.id, user_two.id, "pending")

      friend_request =
        friend_request
        |> Repo.preload([:requesting_user, :requested_user])

      assert friend_request.requesting_user.id == user_one.id
      assert friend_request.requested_user.id == user_two.id
    end

    test "with invalid requester id" do
      {:ok, user} = User.create(@user_one_params)

      {:error, changeset} = FriendRequest.create(user.id, 2 * user.id, "pending")

      refute changeset.valid?
    end

    test "with invalid requestee id" do
      {:ok, user} = User.create(@user_one_params)

      {:error, changeset} = FriendRequest.create(2 * user.id, user.id, "pending")

      refute changeset.valid?
    end

    test "with invalid status" do
      {:ok, user} = User.create(@user_one_params)

      {:error, changeset} = FriendRequest.create(1, user.id, "itscomplicated")

      refute changeset.valid?
    end

    test "with creating the same friend_request relationship twice is invalid" do
      {:ok, user_one} = User.create(@user_one_params)
      {:ok, user_two} = User.create(@user_two_params)

      {:ok, _friend_request} = FriendRequest.create(user_one.id, user_two.id, "pending")
      {:error, changeset} = FriendRequest.create(user_one.id, user_two.id, "pending")
      {:error, _changeset} = FriendRequest.create(user_two.id, user_one.id, "pending")

      refute changeset.valid?
    end
  end
end
