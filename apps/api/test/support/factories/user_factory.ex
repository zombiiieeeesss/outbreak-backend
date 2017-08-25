defmodule API.User.Factory do
  use ExMachina.Ecto, repo: DB.Repo

  def create_user(attrs \\ %{}) do
    build(:user_params, attrs)
    |> API.User.create
    |> elem(1)
  end

  def user_params_factory do
    %{
      username: sequence(:username, &"email-#{&1}@example.com"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "password"
    }
  end
end
