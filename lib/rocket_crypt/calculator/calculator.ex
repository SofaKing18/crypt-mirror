defmodule RocketCrypt.Calculator do
  import RocketCrypt.Rates

  alias RocketCrypt.Rates.Crypt

  @moduledoc """
  Модуль производит операции калькулятора для криптовалют
  """

  @doc """
  Функция принимает на вход количество валюты, ее символ и опционально таймштамп

  Если таймштамп не передан - берется последний курс валюты, иначе ближайший к таймштампу
  """
  @spec to_usd(Decimal.t(), String.t(), NaiveDateTime.t()) :: Decimal.t()
  def to_usd(quantity, crypt_symbol, timestamp \\ nil) do
    case timestamp do
      nil -> latest_rate(crypt_symbol)
      _ -> nearest_to_datetime_crypt(crypt_symbol, timestamp)
    end
    |> multiply(quantity)
  end

  defp multiply(%Crypt{} = crypt, decimal) do
    Decimal.mult(crypt.usd, decimal)
  end

  defp multiply(crypt, _decimal) when is_nil(crypt) do
    Decimal.new(0.0)
  end
end
