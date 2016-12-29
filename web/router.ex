defmodule ConcertBooking.Router do
  use ConcertBooking.Web, :router

  pipeline :session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug ConcertBooking.CurrentUser
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", ConcertBooking do
    pipe_through [:browser, :session]

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/concerts", ConcertController

    post "/book", BookingController, :book
    post "/unbook", BookingController, :unbook
  end

  scope "/api", ConcertBooking do
    pipe_through [:api, :session]

    get "/concerts", ConcertController, :index_api

    post "/book", BookingController, :book_api
    post "/unbook", BookingController, :unbook_api
  end
end
