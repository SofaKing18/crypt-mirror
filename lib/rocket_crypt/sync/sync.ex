defmodule RocketCrypt.Sync do
  @moduledoc """
  Генсервер опрашивает апи о изменениях курса и пишет их в БД
  """

  require Logger
  use GenServer

  @timeout 5000

  alias RocketCrypt.Sync.CryptcompareApi
  import RocketCrypt.Rates

  def crypts do
    Application.get_env(:rocket_crypt, :crypt)
  end

  def start_link(init_state \\ Application.get_env(:rocket_crypt, :crypt)) do
    GenServer.start_link(
      __MODULE__,
      init_state
    )
  end

  def init(state) do
    sync_job()
    {:ok, state}
  end

  def handle_info(:sync_job, state) do
    spawn(fn ->
      Map.to_list(CryptcompareApi.multiprice_usd(state))
      |> Enum.each(fn {symbol, %{"USD" => usd}} ->
        create_crypt(%{usd: usd, symbol: symbol})
      end)
    end)

    sync_job()
    {:noreply, state}
  end

  defp sync_job() do
    Process.send_after(self(), :sync_job, @timeout)
  end
end
