defmodule Registrar.User.Authorization do
  @moduledoc """
  Module for user authorization
  """

  alias Registrar.User.{Authentication}

  def authorize(%{"email" => email, "password" => password}) do
    with user when is_map(user) <- DB.User.get_by_email(email),
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
  defp check_password(password, user), do: Comeonin.Bcrypt.checkpw(password, user.password)

  def hash_password(%{"password" => password} = params) do
    hashed_password = Comeonin.Bcrypt.hashpwsalt(password)
    Map.put(params, "password", hashed_password)
  end
end
