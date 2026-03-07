defmodule ProductManagerCore.Repo.Migrations.RemoveUniqueIndexProductsProviderId do
  use Ecto.Migration

  def change do
    drop unique_index(:products, [:provider_id])
    create index(:products, [:provider_id])
  end
end
