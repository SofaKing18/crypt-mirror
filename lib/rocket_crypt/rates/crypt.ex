defmodule RocketCrypt.Rates.Crypt do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias RocketCrypt.Rates
  alias RocketCrypt.Rates.Crypt

  schema "crypt_rates" do
    field(:symbol, :string)
    field(:usd, :decimal)

    timestamps()
  end

  @doc false
  def changeset(crypt, attrs) do
    crypt
    |> cast(attrs, [:symbol, :usd])
    |> validate_required([:symbol, :usd])
    |> validate_rate_changed()
  end

  @doc """
  Чтобы не захламлять БД одним и тем же курсом, будем проверять, изменился ли c момента последней записи
  """
  def validate_rate_changed(changeset) do
    get_change(changeset, :symbol)
    |> Rates.latest_rate()
    |> case do
      %Crypt{} = result ->
        case result.usd == get_change(changeset, :usd) do
          true -> add_error(changeset, :usd, "Rate didn't change")
          false -> changeset
        end

      _ ->
        changeset
    end
  end
end
