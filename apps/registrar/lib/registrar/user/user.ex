defmodule Registrar.User do
  @moduledoc """
  Context for users
  """

  alias Registrar.User.{Authorization}

  def create_user(attrs) do
    attrs
    |> Authorization.hash_password
    |> DB.User.create_user
  end

  def login(attrs), do: Authorization.authorize(attrs)
end
