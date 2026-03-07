defmodule ProductManagerCore.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProductManagerCore.Catalog.Provider
  alias ProductManagerCore.Catalog.Category

  @valid_statuses ~w(draft active inactive archived)
  @valid_stock_statuses ~w(in_stock out_of_stock low_stock)

  schema "products" do
    field :name, :string
    field :description, :string
    field :stock, :integer
    field :amount, :decimal
    field :url_image, :string
    field :slug, :string
    field :active, :boolean, default: false
    field :status_stock, :string, default: "in_stock"
    field :status, :string, default: "inactive"

    many_to_many(:categories, Category,
      join_through: "product_categories",
      on_replace: :delete
    )

    belongs_to :provider, Provider
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :description,
      :stock,
      :amount,
      :url_image,
      :slug,
      :status,
      :active,
      :status_stock,
      :provider_id
    ])
    |> validate_required([:name, :stock, :amount, :slug, :provider_id])
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_inclusion(:status_stock, @valid_stock_statuses)
    |> validate_number(:stock, greater_than_or_equal_to: 0)
    |> validate_number(:amount, greater_than: 0)
    |> validate_slug(attrs)
    |> unique_constraint(:slug)
    |> foreign_key_constraint(:provider_id)
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
