defmodule API.Web.UserView do
  use API.Web, :view

  def render("search.json", %{users: users}), do: render_users(users)
  def render("create.json", user), do: render_user(user)
  def render("login.json", %{user: user, token: token, exp: exp}) do
    %{
      user: render_user(user),
      auth: %{
        token: token,
        expires_at: exp
      }
    }
  end
  def render("refresh.json", %{token: token, exp: exp}) do
    %{
      auth: %{
        token: token,
        expires_at: exp
      }
    }
  end

  defp render_users(users) do
    %{users: Enum.map(users, &render_user/1)}
  end

  def render_user(user) do
    %{
      id: user.id,
      email: user.email,
      username: user.username
    }
  end
end
