defmodule Registrar.User do
  @moduledoc """
  Context for users
  """

  def create_user(attrs), do: DB.User.create(attrs)
end
