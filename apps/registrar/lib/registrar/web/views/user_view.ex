defmodule Registrar.Web.UserView do
  use Registrar.Web, :view

  def render("create.json", user), do: render_user(user)
  def render("login.json", %{user: user, jwt: jwt}) do
    %{user: render_user(user), jwt: jwt}
  end

  defp render_user(user) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
