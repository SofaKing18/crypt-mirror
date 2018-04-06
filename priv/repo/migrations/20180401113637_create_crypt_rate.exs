defmodule RocketCrypt.Repo.Migrations.CreateCryptRate do
  use Ecto.Migration

  def change do
    create table(:crypt_rates) do
      add(:symbol, :string)
      add(:usd, :decimal)

      timestamps()
    end

    create(index("crypt_rates", [:symbol, :usd, :inserted_at]))
  end
end
