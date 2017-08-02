defmodule API.User do
  @moduledoc """
  Context for users
  """

  alias API.User.{Authorization}

  def create(attrs) do
    DB.User.create(attrs)
  end

  def login(attrs), do: Authorization.authorize(attrs)
end