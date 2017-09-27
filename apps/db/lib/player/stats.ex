defmodule DB.Player.Stats do
  @moduledoc """
  This module encapsulates the functionality for player stats.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key :false
  embedded_schema do
    field :distance, :integer
  end

  @fields [:distance]

  def changeset(struct, params) do
    struct
    |> cast(params, @fields)
  end
end
