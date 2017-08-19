defmodule DB.User do
  @moduledoc """
  This module encapsulates the functionality of the `users` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DB.{Friendship, Game, Player, Repo, User}

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    has_many :friend_requests, Friendship, foreign_key: :requestee_id
    has_many :friend_requested, Friendship, foreign_key: :requester_id
    has_many :friends_requesting_user, through: [:friend_requests, :requester]
    has_many :friends_user_requested, through: [:friend_requested, :requestee]

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
