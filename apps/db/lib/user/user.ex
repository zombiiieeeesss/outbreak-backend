defmodule DB.User do
  @moduledoc """
  This module encapsulates the functionality of the `users` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DB.User

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  @fields [:email, :password, :username]

  def create(attrs) do
    %User{}
    |> registration_changeset(attrs)
    |> DB.Repo.insert
  end

  def get_by_username(username) do
    DB.Repo.one(
      from(
        u in User,
        where: fragment("lower(username) = ?", ^String.downcase(username))
    ))
  end

  def get(id) do
    DB.Repo.get(User, id)
  end

  def registration_changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> generate_encrypted_password
  end

  defp generate_encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
