defmodule RocketCryptWeb.PageController do
  use RocketCryptWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
