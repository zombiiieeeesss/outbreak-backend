defmodule DB.Game do
  @moduledoc """
  This module encapsulates the functionality of the `game` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias DB.Game

  schema "games" do
    field :status, :string
    field :title, :string
    field :round_length, :integer

    timestamps()
  end

  @fields [:status, :title, :round_length]

  def create(attrs) do
    %Game{}
    |> changeset(attrs)
    |> DB.Repo.insert
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
