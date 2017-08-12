defmodule DB.Player do
  @moduledoc """
  This module encapsulates the functionality of the `players` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets. The players table is a join table between users
  and games.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias DB.{Game, Player, User}

  schema "players" do
    belongs_to :user, User
    belongs_to :game, Game
    timestamps()
  end

  @fields [:user_id, :game_id]

  def create(user_id, game_id) do
    %Player{}
    |> changeset(%{user_id: user_id, game_id: game_id})
    |> DB.Repo.insert
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
