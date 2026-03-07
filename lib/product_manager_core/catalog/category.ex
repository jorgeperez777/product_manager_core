defmodule ProductManagerCore.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProductManagerCore.Catalog.Product

  schema "categories" do
    field :active, :boolean, default: false
    field :name, :string
    field :slug, :string
    field :url_image, :string
    field :status, :string, default: "inactive"
    many_to_many :products, Product, join_through: "product_categories"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :active, :url_image, :slug, :status])
    |> validate_required([:name, :active, :slug, :status])
    |> unique_constraint(:slug)
    |> validate_inclusion(:status, ~w(active inactive))
    |> validate_slug(attrs)
  end

  def validate_slug(changeset, attrs) do
    case changeset do
      %{changes: %{name: name}} ->
        changeset
        |> put_change(
          :slug,
          generate_slug_name(name, attrs)
        )

      _ ->
        changeset
    end
  end

  def generate_slug_name(name, _attrs) do
    name
    |> String.normalize(:nfd)
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9-\s]/u, "")
    |> String.replace(~r/\s/, "-")
  end
end
