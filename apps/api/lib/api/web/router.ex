defmodule API.Web.Router do
  use API.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", API.Web do
    pipe_through :api

    get "/up", UpController, :up
  end

 scope "/v1", API.Web do
    pipe_through :api

    scope "/users" do
      post "/", UserController, :create
      post "/login", UserController, :login
      post "/refresh", UserController, :refresh
    end

    resources "/games", GameController, only: [:create]
  end
end
