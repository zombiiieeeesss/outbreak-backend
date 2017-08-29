defmodule DB.FriendRequest do
  @moduledoc """
  This module encapsulates the functionality of the `friend_requests` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets. The friend_requests table is a self-referential
  join table between users.
  """
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias DB.{FriendRequest, Repo, User}

  schema "friend_requests" do
    field :status, :string

    belongs_to :requesting_user, User
    belongs_to :requested_user, User

    timestamps()
  end

  @fields [:requesting_user_id, :requested_user_id, :status]
  @accepted_statuses ~w(pending accepted)

  def create(requesting_user_id, requested_user_id, status) do
    %FriendRequest{}
    |> changeset(%{requesting_user_id: requesting_user_id, requested_user_id: requested_user_id, status: status})
    |> Repo.insert
  end

  def create(requesting_user_id, requested_user_id)
    when requesting_user_id == requested_user_id do
      {:error, ["Users cannot request themselves"]}
  end

  def delete(id) do
    case Repo.get(FriendRequest, id) do
      nil -> {:error, ["friend request does not exist"]}
      fr -> Repo.delete(fr)
    end
  end

  def update(id, params) do
    case Repo.get(FriendRequest, id) do
      nil -> {:error, ["friend request does not exist"]}
      fr ->
        fr
        |> changeset(params)
        |> Repo.update
    end
  end

  def list_by_user(user_id) do
    query = from(f in FriendRequest,
      where: f.requesting_user_id == ^user_id or f.requested_user_id == ^user_id,
      preload: [:requesting_user, :requested_user],
      select: f
    )

    Repo.all(query)
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> assoc_constraint(:requesting_user)
    |> assoc_constraint(:requested_user)
    |> validate_inclusion(:status, @accepted_statuses)
    |> unique_constraint(:requester_requestee, [name: :requester_requestee])
  end
end
