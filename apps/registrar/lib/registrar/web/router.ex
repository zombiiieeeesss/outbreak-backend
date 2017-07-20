defmodule Registrar.Web.Router do
  use Registrar.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/user", Registrar.Web do
    pipe_through :api

    post "/", UserController, :create
  end
end
