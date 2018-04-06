defmodule RocketCrypt.CalculatorTest do
  use RocketCrypt.DataCase

  alias RocketCrypt.Rates
  alias RocketCrypt.Calculator

  describe "RocketCrypt.Calculator" do
    test "multiply - existing crypt" do
      Rates.create_crypt(%{symbol: "BTC", usd: 256.0})
      assert Decimal.equal?(Calculator.to_usd(2, "BTC"), 512)
    end

    test "multiply - unexisting crypt" do
      assert Decimal.equal?(Calculator.to_usd(2, "ASDF"), 0)
    end

    test "multiply - existing crypt and datetime" do
      now = NaiveDateTime.utc_now()
      Rates.create_crypt(%{symbol: "C1", usd: 1.5})
      Rates.create_crypt(%{symbol: "C1", usd: 1.6})
      Rates.create_crypt(%{symbol: "C1", usd: 1.973})

      assert Decimal.equal?(Calculator.to_usd(4, "C1", now), 6)

      assert Decimal.equal?(
               Calculator.to_usd(2, "C1", NaiveDateTime.utc_now()),
               Decimal.new(3.946)
             )
    end
  end
end
