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

    belongs_to :requester, User
    belongs_to :requestee, User

    timestamps()
  end

  @fields [:requester_id, :requestee_id, :status]
  @accepted_statuses ~w(pending accepted)

  def create(requester_id, requestee_id, status) do
    %FriendRequest{}
    |> changeset(%{requester_id: requester_id, requestee_id: requestee_id, status: status})
    |> Repo.insert
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> assoc_constraint(:requester)
    |> assoc_constraint(:requestee)
    |> validate_inclusion(:status, @accepted_statuses)
    |> unique_constraint(:requester_requestee, [name: :requester_requestee])
  end
end
