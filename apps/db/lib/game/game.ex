defmodule DB.Game do
  @moduledoc """
  This module encapsulates the functionality of the `game` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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

  def list_by_user(%User{} = user) do
    list_by_user(user.id)
  end

  def list_by_user(user_id) do
    Repo.all(
      from g in Game,
        join: p in Player, on: p.user_id == ^user_id
    )
  end

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
