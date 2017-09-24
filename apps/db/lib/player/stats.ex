defmodule DB.Player.Stats do
  @moduledoc """
  This module encapsulates the functionality for player stats.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key :false
  embedded_schema do
    field :steps, :integer
  end

  @fields [:steps]

  def changeset(struct, params) do
    struct
    |> cast(params, @fields)
  end
end
