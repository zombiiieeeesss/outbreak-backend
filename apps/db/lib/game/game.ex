defmodule DB.Game do
  @moduledoc """
  This module encapsulates the functionality of the `game` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias DB.{Game, Player, Repo, User}

  schema "games" do
    field :status, :string
    field :title, :string
    field :round_length, :integer

    many_to_many :users, User, join_through: Player
    timestamps()
  end

  @fields [:status, :title, :round_length]
  @required_fields [:status, :round_length]
  @accepted_statuses ~w(pending active complete)

  def create(attrs) do
    %Game{}
    |> changeset(attrs)
    |> Repo.insert
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:status, @accepted_statuses)
  end
end
