defmodule Registrar.Web.UserView do
  use Registrar.Web, :view

  def render("create.json", user) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
