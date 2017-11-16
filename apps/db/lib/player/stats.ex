defmodule DB.Player.Stats do
  @moduledoc """
  This module encapsulates the functionality for player stats.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key :false

  embedded_schema do
    field :distance, :integer
    field :is_human, :boolean, default: true
  end

  @fields [:distance, :is_human]

  def changeset(struct, params) do
    struct
    |> cast(params, @fields)
  end
end
