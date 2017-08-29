defmodule API.User do
  @moduledoc """
  Context for users
  """

  alias API.User.{Authorization}

  def create(attrs), do: DB.User.create(attrs)

  def login(attrs), do: Authorization.authorize(attrs)

  def get_by_username(username), do: DB.User.get_by_username(username)
  def search_users(query, options), do: DB.User.search_users(query, options)
end
