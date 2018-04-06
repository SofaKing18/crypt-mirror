defmodule RocketCryptWeb.Router do
  use RocketCryptWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/", RocketCryptWeb do
    pipe_through(:api)

    get("/calcalator/to_usd", CalculatorController, :to_usd)
  end

  scope "/", RocketCryptWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", RocketCryptWeb do
  #   pipe_through :api
  # end
end
