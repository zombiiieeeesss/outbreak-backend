defmodule API.User.Authorization do
  @moduledoc """
  Module for user authorization
  """

  alias API.User.{Authentication}

  def authorize(%{"username" => username, "password" => password}) do
    with user when is_map(user) <- DB.User.get_by_username(username),
                           true <- check_password(password, user)
    do
      {jwt, exp} = Authentication.generate_token(user)
      {:ok, user, jwt, exp}
    else
      _err -> {:error, :unauthorized}
    end
  end

  defp check_password(_password, nil) do
    Comeonin.Bcrypt.dummy_checkpw
    false
  end

  defp check_password(password, user), do: Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
end
