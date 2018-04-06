defmodule RocketCryptWeb.AdminChannel do
  use Phoenix.Channel
  import RocketCrypt.Sync.Broadcaster
  import NaiveDateTime, only: [from_iso8601!: 1]

  def join("rate_fixation", _message, socket) do
    {:ok, "joined to admin channel", socket}
  end

  def handle_in("fix", %{"fix_ts" => ts, "fix_till" => fix_till}, socket) do
    fix_rate(from_iso8601!(ts), from_iso8601!(fix_till))
    {:reply, :ok, socket}
  end
end
