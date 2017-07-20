defmodule Registrar.Web.Router do
  use Registrar.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.VerifyHeader
  end

  scope "/user", Registrar.Web do
    pipe_through :api

    post "/", UserController, :create
    post "/login", UserController, :login
  end
end
