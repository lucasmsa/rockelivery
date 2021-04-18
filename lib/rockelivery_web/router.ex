defmodule RockeliveryWeb.Router do
  use RockeliveryWeb, :router
  alias RockeliveryWeb.Plugs.UUIDChecker

  pipeline :api do
    plug(:accepts, ["json"])
    plug(UUIDChecker)
  end

  pipeline :auth do
    plug(RockeliveryWeb.Auth.Pipeline)
  end

  scope "/api", RockeliveryWeb do
    pipe_through(:api)

    get("/", WelcomeController, :index)
    post("/users", UsersController, :create)

    post("/users/signin", UsersController, :sign_in)
  end

  scope "/api", RockeliveryWeb do
    pipe_through([:api, :auth])

    resources("/users", UsersController, except: [:new, :edit, :create])

    resources("/items", ItemsController, except: [:new, :edit])
    post("/orders", OrdersController, :create)
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: RockeliveryWeb.Telemetry)
    end
  end
end
