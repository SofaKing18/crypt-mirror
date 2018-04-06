defmodule RocketCrypt.Rates do
  @moduledoc """
  Модуль пишет курсы криптовалют в БД
  """

  import Ecto.Query, warn: false
  alias RocketCrypt.Repo
  alias RocketCrypt.Rates.Crypt
  alias RocketCrypt.Sync.Broadcaster

  @doc """
  Функция возвращает ближайщий к указанному времени курс валюты

  ## Примеры

      iex> nearnest_to_datetime_rate("BTC", ~N[2018-04-05 21:44:26.569982])
      %Crypt{}
  """
  @spec nearest_to_datetime_crypt(String.t(), NaiveDateTime.t()) :: Crypt.t() | nil
  def nearest_to_datetime_crypt(symbol, datetime) do
    sort_crypts(close_less(symbol, datetime), close_higher(symbol, datetime), datetime)
    |> List.first()
  end

  defp sort_crypts(%Crypt{} = crypt1, %Crypt{} = crypt2, datetime) do
    [crypt1, crypt2]
    |> Enum.sort(&(score_from_datetime(&1, datetime) <= score_from_datetime(&2, datetime)))
  end

  defp sort_crypts(crypt1, crypt2, _datetime) when is_nil(crypt1) or is_nil(crypt2) do
    crypts = [crypt1, crypt2]

    case is_nil(List.first(crypts)) do
      true -> Enum.reverse(crypts)
      false -> crypts
    end
  end

  defp score_from_datetime(%Crypt{} = crypt, datetime) do
    NaiveDateTime.diff(crypt.inserted_at, datetime) |> abs
  end

  defp close_less(symbol, datetime) do
    from(
      c in Crypt,
      where: c.symbol == ^symbol,
      where: c.inserted_at <= ^datetime,
      order_by: [desc: c.inserted_at],
      limit: 1
    )
    |> Repo.one()
  end

  defp close_higher(symbol, datetime) do
    from(
      c in Crypt,
      where: c.symbol == ^symbol,
      where: c.inserted_at >= ^datetime,
      order_by: [asc: c.inserted_at],
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Функция возвращает последний курс для выбранной валюты

  ## Пример

    iex> latest_rate("BTC")
    %Crypt{}
  """
  @spec latest_rate(String.t()) :: Crypt.t() | nil
  def latest_rate(symbol) when not is_nil(symbol) do
    from(
      c in Crypt,
      where: c.symbol == ^symbol,
      order_by: [desc: c.inserted_at],
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Функция создает из запись структуры Crypt в случае успеха, а в случае 
  неудачи возвращает Ecto.Changeset

  ## Примеры

      iex> create_crypt(%{field: value})
      %Crypt{}}

      iex> create_crypt(%{field: bad_value})
      %Ecto.Changeset{}}
  """
  @spec create_crypt(Map.t()) :: Crypt.t() | Ecto.Changeset.t()
  def create_crypt(attrs \\ %{}) do
    {_result_atom, result} =
      %Crypt{}
      |> Crypt.changeset(attrs)
      |> Repo.insert()

    result |> Broadcaster.update_rate()
    result
  end
end
