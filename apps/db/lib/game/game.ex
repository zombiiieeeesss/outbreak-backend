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
    field :owner_id, :integer
    field :round, :integer
    field :round_length, :integer
    field :round_limit, :integer
    field :start_time, :utc_datetime

    many_to_many :users, User, join_through: Player
    has_many :players, Player

    timestamps()
  end

  @fields [:status, :round, :title, :owner_id, :round_length, :round_limit, :start_time]
  @required_fields [:status, :round, :round_length, :round_limit, :owner_id, :start_time]
  @accepted_statuses ~w(qualifying active complete)

  def get(game_id), do: Repo.get(Game, game_id)

  def list_by_user(user) do
    user
    |> Ecto.assoc(:games)
    |> Repo.all
  end

  def create(attrs) do
    %Game{round: 1}
    |> changeset(attrs)
    |> Repo.insert
  end

  def delete(game) do
    Repo.delete(game)
  end

  def update(game, attrs) do
    game
    |> changeset(attrs)
    |> Repo.update
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:status, @accepted_statuses)
  end
end
