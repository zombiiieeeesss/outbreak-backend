defmodule DB.Player do
  @moduledoc """
  This module encapsulates the functionality of the `players` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets. The players table is a join table between users
  and games.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Multi
  alias DB.{Game, Player, Repo, User}

  schema "players" do
    field :status, :string

    belongs_to :user, User
    belongs_to :game, Game

    timestamps()
  end

  @fields [:user_id, :game_id, :status]
  @accepted_statuses ~w(user-pending active)

  def create(attrs) do
    %Player{}
    |> changeset(attrs)
    |> Repo.insert
  end

  def bulk_create(attr_list) do
    multi = Multi.new

    attr_list
    |> Enum.with_index
    |> Enum.reduce(multi, fn({attrs, i}, multi) ->
      Multi.insert(multi, i, changeset(%Player{}, attrs))
    end)
    |> Repo.transaction
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:status, @accepted_statuses)
    |> assoc_constraint(:user)
    |> assoc_constraint(:game)
  end
end
