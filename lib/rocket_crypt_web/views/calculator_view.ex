defmodule RocketCryptWeb.CalculatorView do
  use RocketCryptWeb, :view

  def render("to_usd.json", %{usd: usd}) do
    %{usd: usd}
  end
end
