defmodule DB.User do
  @moduledoc """
  This module encapsulates the functionality of the `users` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DB.{Game, Player, Repo, User}

  @levenshtein Application.get_env(:db, :levenshtein_distance)

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    many_to_many :games, Game, join_through: Player

    timestamps()
  end

  @fields [:email, :password, :username]

  def create(attrs) do
    %User{}
    |> registration_changeset(attrs)
    |> Repo.insert
  end

  def get_by_username(username) do
    DB.Repo.one(
      from(
        u in User,
        where: fragment("lower(username) = ?", ^String.downcase(username))
    ))
  end

  @doc """
  Searches for users by `username`. Uses levenshtein distance
  to determine matches, up to a distance of 5.
  """
  def search_users(username: query_string) do
    DB.Repo.all(
      from u in User,
      where: fragment(
        "levenshtein(lower(?), lower(?))", u.username, ^query_string
      ) < @levenshtein,
      order_by: fragment("levenshtein(lower(?), lower(?))", u.username, ^query_string),
      limit: 10
    )
  end

  @doc """
  Searches for users by `email`. Uses levenshtein distance
  to determine matches, up to a distance of 5.
  """
  def search_users(email: query_string) do
    DB.Repo.all(
      from u in User,
      where: fragment(
        "levenshtein(lower(?), lower(?))", u.email, ^query_string
      ) < @levenshtein,
      order_by: fragment("levenshtein(lower(?), lower(?))", u.email, ^query_string),
      limit: 10
    )
  end

  def get(id) do
    Repo.get(User, id)
  end

  def registration_changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email, name: :lowercase_email)
    |> unique_constraint(:username, name: :lowercase_username)
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
