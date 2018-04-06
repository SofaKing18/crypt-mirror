defmodule RocketCryptWeb.AdminChannelTest do
  use RocketCryptWeb.ChannelCase

  alias RocketCryptWeb.AdminChannel
  import RocketCrypt.Sync.Broadcaster

  setup do
    {:ok, _, socket} =
      socket("/admin", %{some: :assign})
      |> subscribe_and_join(AdminChannel, "rate_fixation")

    {:ok, socket: socket}
  end

  describe "RocketCryptWeb.AdminChannel" do
    test "channel behaviour", %{socket: socket} do
      fix_time = NaiveDateTime.utc_now()
      fix_till = NaiveDateTime.add(fix_time, 3600)

      push(socket, "fix", %{"fix_ts" => to_string(fix_time), "fix_till" => to_string(fix_till)})

      assert rate_fixed?()
    end
  end
end
