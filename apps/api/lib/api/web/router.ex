defmodule API.Web.Router do
  use API.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.VerifyHeader
  end

  scope "/", API.Web do
    pipe_through :api

    get "/up", UpController, :up
  end

  scope "/user", API.Web do
    pipe_through :api

    post "/", UserController, :create
    post "/login", UserController, :login
    post "/refresh", UserController, :refresh
  end
end
