defmodule UserTest do
  use DB.ModelCase

  @params %{
    username: "Obi-Wan",
    email: "obi-wan@jedicouncil.org",
    password: "ihavethehighground"
  }

  defp is_valid(%Ecto.Changeset{valid?: valid}), do: valid

  describe "changesets" do
    test "changeset is valid with username, email, password" do
      changeset = DB.User.registration_changeset(%DB.User{}, @params)

      assert is_valid(changeset)
    end

    test "changeset is invalid with improper email format" do
      params = %{@params | email: "wrong"}
      changeset = DB.User.registration_changeset(%DB.User{}, params)

      assert not is_valid(changeset)
    end

    test "changeset is invalid with improper password length" do
      params = %{@params | password: "short"}
      changeset = DB.User.registration_changeset(%DB.User{}, params)

      assert not is_valid(changeset)
    end
  end

  describe "model" do
    test "cannot create a user with existing username" do
      DB.User.registration_changeset(%DB.User{}, @params) |> DB.Repo.insert!
      {:error, _changeset} =
        DB.User.registration_changeset(%DB.User{}, @params)
        |> DB.Repo.insert
    end

    test "cannot create a user with existing email" do
      DB.User.registration_changeset(%DB.User{}, @params) |> DB.Repo.insert!
      params = %{@params | username: "dude"}
      {:error, _changeset} =
        DB.User.registration_changeset(%DB.User{}, params)
        |> DB.Repo.insert
    end
  end
end
