defmodule UserTest do
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
end
