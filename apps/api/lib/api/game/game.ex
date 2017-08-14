defmodule API.Game do
  @moduledoc """
  Context for games
  """
  def list(user) do
    DB.Game.list_by_user(user)
  end

  def create(attrs) do
    DB.Game.create(attrs)
  end

end
