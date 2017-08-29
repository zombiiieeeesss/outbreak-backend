defmodule DB.UserTest do
  use DB.ModelCase

  alias DB.User

  @params %{
    username: "Obi-Wan",
    email: "obi-wan@jedicouncil.org",
    password: "ihavethehighground"
  }

  describe "changesets" do
    test "changeset is valid with username, email, password" do
      changeset = User.registration_changeset(%User{}, @params)

      assert is_valid(changeset)
    end

    test "changeset is invalid with improper email format" do
      params = %{@params | email: "wrong"}
      changeset = User.registration_changeset(%User{}, params)

      assert not is_valid(changeset)
    end

    test "changeset is invalid with improper password length" do
      params = %{@params | password: "short"}
      changeset = User.registration_changeset(%User{}, params)

      assert not is_valid(changeset)
    end
  end

  describe "model" do
    test "cannot create a user with existing username" do
      %User{} |> User.registration_changeset(@params) |> DB.Repo.insert!
      {:error, _changeset} =
        %User{}
        |> User.registration_changeset(@params)
        |> DB.Repo.insert
    end

    test "cannot create a user with existing email" do
      %User{} |> User.registration_changeset(@params) |> DB.Repo.insert!
      params = %{@params | username: "dude"}
      {:error, _changeset} =
        %User{}
        |> User.registration_changeset(params)
        |> DB.Repo.insert
    end
  end

  describe "#search_users" do
    setup do
      {:ok, user} = DB.User.create(@params)
      {:ok, user: user}
    end

    test "by exact username returns a user", %{user: user} do
      [searched_user] = DB.User.search_users(@params.username)
      assert searched_user.username == user.username
    end

    test "by exact username, case insensitive, returns a user", %{user: user} do
      [searched_user] =
        DB.User.search_users(String.upcase(@params.username))
      assert searched_user.username == user.username
    end

    test "by fuzzy username, distance 4 returns a user", %{user: user} do
      [searched_user] = DB.User.search_users("obi")
      assert searched_user.username == user.username
    end

    test "by fuzzy username, distance 5 or greater returns nothing" do
      assert [] = DB.User.search_users("ob")
    end

    test "by exact email returns a user", %{user: user} do
      [searched_user] = DB.User.search_users(@params.email)
      assert searched_user.username == user.username
    end

    test "by exact email, case insensitive returns a user", %{user: user} do
      [searched_user] = DB.User.search_users(String.upcase(@params.email))
      assert searched_user.username == user.username
    end

    test "by fuzzy email, distance 4 returns a user", %{user: user} do
      [searched_user] = DB.User.search_users("obiwan@jedicouncil.net")
      assert searched_user.username == user.username
    end

    test "by fuzzy email, distance 5 or greater returns nothing" do
      assert [] = DB.User.search_users("@jedicouncil")
    end

    test "with an `except` option excludes a user by username", %{user: user} do
      params = %{@params | username: "Obi Wan", email: "obiwan@jedicouncil"}
      {:ok, other_user} = DB.User.create(params)
      [result] = DB.User.search_users(@params.username, except: user)
      assert result.username == other_user.username
    end

    test "with an `except` option excludes a user by email", %{user: user} do
      params = %{@params | username: "Old Ben Kenobi", email: "obi-wan@jedicouncil"}
      {:ok, other_user} = DB.User.create(params)
      [result] = DB.User.search_users(@params.email, except: user)
      assert result.email == other_user.email
    end
  end
end
