defmodule RocketCrypt.Sync.CryptcompareApi do
  require Logger

  @doc """
  Функция запрашивает текущую стоимость криптовалют в долларах США

  ## Пример:

    iex> multiprice_usd([:BTC, :ETH]) 
    %{"BTC" => %{"USD" => 6935.52}, "ETH" => %{"USD" => 394.22}}
  """
  @spec multiprice_usd(List[Atom.t()]) :: Hash | nil
  def multiprice_usd(crypt_sign_list) when is_list(crypt_sign_list) do
    crypts = Enum.join(crypt_sign_list, ",")
    request("pricemulti?fsyms=#{crypts}&tsyms=USD")
  end

  @spec request(String.t()) :: Hash | nil
  defp request(url) do
    case HTTPotion.get("https://min-api.cryptocompare.com/data/" <> url) do
      %HTTPotion.Response{} = response ->
        response.body
        |> Poison.decode!()

      %HTTPotion.ErrorResponse{} = error ->
        Logger.error("#{url} -> #{inspect(error)}")
        %{}

      _ ->
        Logger.error("#{url} got something wrong")
        %{}
    end
  end
end
