defmodule RocketCryptWeb.RateChannelTest do
  use RocketCryptWeb.ChannelCase

  alias RocketCryptWeb.RateChannel
  import RocketCrypt.Sync.Broadcaster

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(RateChannel, "crypt_rate_BTC")

    {:ok, socket: socket}
  end

  describe "RocketCryptWeb.RateChannel" do
    test "channel behaviour", %{socket: _socket} do
      RocketCrypt.Rates.create_crypt(%{symbol: "BTC", usd: 125.34})
      assert_push("rate_update", %{usd: %Decimal{}})

      # фиксируем время отправки, после чего пуши в сокеты не должны отправлятся 
      fix_time = NaiveDateTime.utc_now()
      assert :fixed == fix_rate(fix_time, NaiveDateTime.add(NaiveDateTime.utc_now(), 3600))
      assert rate_fixed?()
      assert fix_time == fixed_time()
      assert_push("rate_update", _any)
      RocketCrypt.Rates.create_crypt(%{symbol: "BTC", usd: 200})
      refute_push("rate_update", _any)
    end
  end
end
