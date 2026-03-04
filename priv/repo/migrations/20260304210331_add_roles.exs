defmodule ProductManagerCore.Repo.Migrations.AddRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create table(:user_roles) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :role_id, references(:roles, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:user_roles, [:user_id, :role_id])
  end
end
