defmodule API.User.Authentication do
  @moduledoc """
  Module for user authentication
  """

  def generate_token(user) do
    {:ok, jwt, %{"exp" => exp}} = Guardian.encode_and_sign(user, :access)
    {jwt, exp}
  end
end
