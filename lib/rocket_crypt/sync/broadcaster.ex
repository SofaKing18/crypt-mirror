defmodule RocketCrypt.Sync.Broadcaster do
  @moduledoc """
  Генсервер сообщает подписчикам сокетов об обновлении курса
  """
  use GenServer

  import RocketCryptWeb.RateChannel
  import RocketCrypt.Rates
  alias RocketCrypt.Rates.Crypt

  def start_link(init_state \\ [fix_rates_at_ts: nil, fix_till: nil]) do
    GenServer.start_link(
      __MODULE__,
      Map.new(init_state),
      name: __MODULE__
    )
  end

  def init(state) do
    {:ok, state}
  end

  @doc """
  Функция указывает на каком и до какого времени зафиксировать рейты 
  """
  @spec fix_rate(NaiveDateTime.t(), NaiveDateTime.t()) :: :fixed

  def fix_rate(fix_rates_at_ts, fix_till) do
    result = GenServer.call(__MODULE__, {:fix_rate, fix_rates_at_ts, fix_till})

    spawn(fn ->
      RocketCrypt.Sync.crypts()
      |> Enum.each(fn crypt ->
        nearest_to_datetime_crypt(to_string(crypt), fix_rates_at_ts)
        |> broadcast_crypt_rate
      end)
    end)

    result
  end

  @doc """
  Функция обновляет рейты в сокетах, только если не было фиксации рейта
  """
  @spec update_rate(Crypt.t()) :: no_return
  def update_rate(rate) do
    GenServer.cast(__MODULE__, {:update_rate, rate})
  end

  @doc """
  Функция возвращает зафиксированы рейты или нет
  """
  def rate_fixed?() do
    GenServer.call(__MODULE__, {:rate_fixed?})
  end

  @doc """
  Функция возвращает время фиксации рейтов
  """
  def fixed_time() do
    GenServer.call(__MODULE__, {:fixed_time})
  end

  # server callbacks

  def handle_call({:rate_fixed?}, _from, state) do
    {:reply, !(NaiveDateTime.utc_now() > state.fix_till), state}
  end

  def handle_call({:fixed_time}, _from, state) do
    {:reply, state.fix_rates_at_ts, state}
  end

  def handle_call({:fix_rate, fix_rates_at_ts, fix_till}, _from, _state) do
    # RocketCrypt.Sync.Broadcaster.fix_rate(~N[2018-04-07 11:20:23.000000], NaiveDateTime.add(NaiveDateTime.utc_now, 3600))

    new_state = %{fix_rates_at_ts: fix_rates_at_ts, fix_till: fix_till}

    {:reply, :fixed, new_state}
  end

  def handle_cast({:update_rate, rate}, state) do
    if NaiveDateTime.utc_now() > state.fix_till do
      broadcast_crypt_rate(rate)
    end

    {:noreply, state}
  end
end
