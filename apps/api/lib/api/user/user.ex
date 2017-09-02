defmodule API.User do
  @moduledoc """
  Context for users
  """

  alias API.User.{Authorization}

  def create(attrs), do: DB.User.create(attrs)

  def login(attrs), do: Authorization.authorize(attrs)

  def get_by_username(username), do: DB.User.get_by_username(username)

  def search(query, user_id) do
    query
    |> DB.User.search
    |> Enum.filter(fn(user) -> user.id != user_id end)
  end
end
