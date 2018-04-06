defmodule RocketCryptWeb.CalculatorController do
  use RocketCryptWeb, :controller

  alias RocketCrypt.Calculator
  import NaiveDateTime, only: [from_iso8601!: 1]

  action_fallback(RocketCryptWeb.FallbackController)

  def to_usd(conn, %{"quantity" => quantity, "crypt" => symbol, "timestamp" => ts}) do
    usd =
      Decimal.new(quantity)
      |> Calculator.to_usd(symbol, from_iso8601!(ts))

    render(conn, "to_usd.json", usd: usd)
  end

  def to_usd(conn, %{"quantity" => quantity, "crypt" => symbol}) do
    usd =
      Decimal.new(quantity)
      |> Calculator.to_usd(symbol)

    render(conn, "to_usd.json", usd: usd)
  end
end
