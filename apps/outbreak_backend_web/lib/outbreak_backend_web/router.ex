defmodule OutbreakBackend.Web.Router do
  use OutbreakBackend.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OutbreakBackend.Web do
    pipe_through :api
  end
end
