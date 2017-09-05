defmodule Factory.User do
  @app Application.get_env(:factory, :app)
  use ExMachina.Ecto, repo: @app.Repo

  def create_user(attrs \\ %{}) do
    build(:user_params, attrs)
    |> @app.User.create
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
