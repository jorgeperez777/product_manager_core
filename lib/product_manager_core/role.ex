defmodule ProductManagerCore.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProductManagerCore.Accounts.User

  schema "roles" do
    field :name, :string
    field :slug, :string
    many_to_many :users, User, join_through: "user_roles"
    timestamps()
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :slug, :user_id])
    |> validate_required([:name, :slug, :user_id])
  end
end
