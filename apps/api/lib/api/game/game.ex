defmodule API.Game do
  @moduledoc """
  Context for games
  """

  def create(attrs) do
    DB.Game.create(attrs)
  end
end
