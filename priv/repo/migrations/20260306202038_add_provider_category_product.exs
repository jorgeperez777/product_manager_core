defmodule ProductManagerCore.Repo.Migrations.AddProviderCategoryProduct do
  use Ecto.Migration

  def change do
    create table(:providers) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :active, :boolean, default: false
      add :telephone, :string
      add :location, :text
      add :url_contact, :text
      add :email, :string, null: false
      add :url_image, :string
      add :status, :string, default: "inactive"
      timestamps()
    end

    create unique_index(:providers, [:slug])
    create unique_index(:providers, [:email])

    create table(:categories) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :active, :boolean, default: false
      add :url_image, :string
      add :status, :string, default: "inactive"

      timestamps()
    end

    create unique_index(:categories, [:slug])

    create table(:products) do
      add :name, :string, null: false
      add :description, :text
      add :stock, :integer, default: 0
      add :url_image, :string
      add :amount, :decimal, precision: 10, scale: 2
      add :provider_id, references(:providers, on_delete: :nilify_all)
      add :slug, :string, null: false
      add :active, :boolean, default: false
      add :status_stock, :string, default: "in_stock"
      add :status, :string, default: "inactive"
      timestamps()
    end

    create unique_index(:products, [:provider_id])
    create unique_index(:products, [:slug])

    create table(:product_categories) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :category_id, references(:categories, on_delete: :delete_all), null: false
    end

    create unique_index(:product_categories, [:product_id, :category_id])
  end
end
