defmodule DB.FriendshipTest do
  use DB.ModelCase

  alias DB.{Friendship, User}

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

      {:ok, friendship} = Friendship.create(user_one.id, user_two.id, "pending")

      friendship =
        friendship
        |> Repo.preload([:requester, :requestee])

      assert friendship.requester.id == user_one.id
      assert friendship.requestee.id == user_two.id
    end

    test "with invalid requester id" do
      {:ok, user} = User.create(@user_one_params)

      {:error, changeset} = Friendship.create(user.id, 2 * user.id, "pending")

      refute changeset.valid?
    end

    test "with invalid requestee id" do
      {:ok, user} = User.create(@user_one_params)

      {:error, changeset} = Friendship.create(2 * user.id, user.id, "pending")

      refute changeset.valid?
    end

    test "with invalid status" do
      {:ok, user} = User.create(@user_one_params)

      {:error, changeset} = Friendship.create(1, user.id, "itscomplicated")

      refute changeset.valid?
    end

    test "with creating the same friendship relationship twice is invalid" do
      {:ok, user_one} = User.create(@user_one_params)
      {:ok, user_two} = User.create(@user_two_params)

      {:ok, _friendship} = Friendship.create(user_one.id, user_two.id, "pending")
      {:error, changeset} = Friendship.create(user_one.id, user_two.id, "pending")

      refute changeset.valid?
    end
  end
end
