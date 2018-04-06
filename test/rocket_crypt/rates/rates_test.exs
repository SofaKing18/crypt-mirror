defmodule RocketCrypt.RatesTest do
  use RocketCrypt.DataCase

  alias RocketCrypt.Rates
  alias RocketCrypt.Rates.Crypt

  describe "RocketCrypt.Rates" do
    test "create_crypt - valid attributes" do
      assert %Crypt{} = Rates.create_crypt(%{symbol: "BTC", usd: 120.5})
    end

    test "create_crypt - returns Ecto.Changeset on error" do
      assert %Ecto.Changeset{} = Rates.create_crypt(%{symbol: "ABC", usd: nil})
    end

    test "create_crypt - same rate doesn't write to base" do
      btc = Rates.create_crypt(%{symbol: "BTC", usd: 120.5})
      assert %Ecto.Changeset{} = Rates.create_crypt(%{symbol: "BTC", usd: 120.5})
      assert btc != Rates.create_crypt(%{symbol: "BTC", usd: 120.51})
    end

    test "latest_rate - returns last added crypt" do
      eth = Rates.create_crypt(%{symbol: "ETH", usd: 222.22})
      assert eth == Rates.latest_rate("ETH")
    end

    test "latest_rate - returns nil for unexisting crypt" do
      assert is_nil(Rates.latest_rate("MOS"))
    end

    test "nearest_to_datetime_crypt - get nearnest less" do
      now = NaiveDateTime.utc_now()
      assert is_nil(Rates.nearest_to_datetime_crypt("BDSM", now))

      bdsm = Rates.create_crypt(%{symbol: "BDSM", usd: 1.0})
      assert bdsm == Rates.nearest_to_datetime_crypt("BDSM", now)
    end

    test "nearest_to_datetime_crypt - get nearnest higher" do
      assert is_nil(Rates.nearest_to_datetime_crypt("BDSM", NaiveDateTime.utc_now()))
      Rates.create_crypt(%{symbol: "BDSM", usd: 1.0})
      bdsm = Rates.create_crypt(%{symbol: "BDSM", usd: 2.0})
      now = NaiveDateTime.utc_now()
      assert bdsm == Rates.nearest_to_datetime_crypt("BDSM", now)
    end
  end
end
