defmodule API.Web.Router do
  use API.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :auth do
    plug Guardian.Plug.EnsureAuthenticated,
      handler: API.Web.UserController
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

    # All routes after this pipeline will require authentication
    pipe_through :auth

    resources "/games", GameController, only: [:index, :create]
    resources "/friendships", FriendshipController, only: [:create]
  end
end
