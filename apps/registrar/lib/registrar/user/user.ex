defmodule Registrar.User do
  @moduledoc """
  Context for users
  """

  def create_user(attrs) do
    attrs
    |> hash_password
    |> DB.User.create_user
  end

  def login(%{"email" => email, "password" => password}) do
    with user when is_map(user) <- DB.User.get_by_email(email),
                           true <- check_password(password, user)
    do
      {:ok, jwt, _claim} = Guardian.encode_and_sign(user, :access)
      {:ok, user, jwt}
    else
      _err -> {:error, :unauthorized}
    end
  end

  defp check_password(_password, nil) do
    Comeonin.Bcrypt.dummy_checkpw
    false
  end
  defp check_password(password, user), do: Comeonin.Bcrypt.checkpw(password, user.password)

  defp hash_password(%{"password" => password} = params) do
    hashed_password = Comeonin.Bcrypt.hashpwsalt(password)

    params
    |> Map.put("password", hashed_password)
  end
end
