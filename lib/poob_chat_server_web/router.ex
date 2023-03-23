defmodule PoobChatServerWeb.Router do
  use PoobChatServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug PoobChatServer.Plug.Authenticate
  end

  scope "/api", PoobChatServerWeb do
    pipe_through :api

    post "/register", UserController, :create
    post "/login", UserSessionController, :create

    pipe_through :authenticated

    get "/message", MessageController, :show
    post "/message", MessageController, :create
    delete "/message", MessageController, :delete

    get "/conversation", ConversationController, :index

    get "/friend", FriendController, :index
    post "/friend", FriendController, :create
    delete "/friend", FriendController, :delete
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: PoobChatServerWeb.Telemetry
    end
  end
end
