defmodule DB.FriendRequest do
  @moduledoc """
  This module encapsulates the functionality of the `friend_requests` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets. The friend_requests table is a self-referential
  join table between users.
  """
  use Ecto.Schema
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
