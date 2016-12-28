defmodule ConcertBooking.Router do
  use ConcertBooking.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug ConcertBooking.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ConcertBooking do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/concerts", ConcertController
    resources "/booking", BookingController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ConcertBooking do
  #   pipe_through :api
  # end
end
