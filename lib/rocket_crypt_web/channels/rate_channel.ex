defmodule RocketCryptWeb.RateChannel do
  use Phoenix.Channel
  alias RocketCrypt.Rates.Crypt
  alias RocketCrypt.Sync.Broadcaster
  import RocketCrypt.Rates

  @channel_prefix "crypt_rate_"

  @doc """
  При подключении к каналу пользователю высылается последний курс по валюте
  """
  def join(@channel_prefix <> crypt_symbol, _message, socket) do
    crypt =
      case Broadcaster.rate_fixed?() do
        true -> nearest_to_datetime_crypt(crypt_symbol, Broadcaster.fixed_time())
        false -> latest_rate(crypt_symbol)
      end || %{usd: nil}

    {:ok, Map.take(crypt, [:usd]), socket}
  end

  @doc """
  Отослать всем подписанным на канал курс валюты
  """
  def broadcast_crypt_rate(%Crypt{} = crypt) do
    RocketCryptWeb.Endpoint.broadcast(
      @channel_prefix <> crypt.symbol,
      "rate_update",
      Map.take(crypt, [:usd])
    )
  end

  def broadcast_crypt_rate(_not_crypt), do: nil
end
