defmodule DB.User.Factory do
  use ExMachina.Ecto, repo: DB.Repo

  def create_user do
    user_params()
    |> DB.User.create
    |> elem(1)
  end

  defp user_params do
    %{
      username: sequence(:username, &"email-#{&1}@example.com"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "password"
    }
  end
end
