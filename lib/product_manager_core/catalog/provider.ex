defmodule ProductManagerCore.Catalog.Provider do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProductManagerCore.Catalog.Product

  schema "providers" do
    field :active, :boolean, default: false
    field :name, :string
    field :location, :string
    field :slug, :string
    field :telephone, :string
    field :url_contact, :string
    field :email, :string
    field :url_image, :string
    field :status, :string, default: "inactive"
    has_many :products, Product
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(provider, attrs) do
    provider
    |> cast(attrs, [
      :name,
      :slug,
      :active,
      :telephone,
      :location,
      :url_contact,
      :email,
      :url_image,
      :status
    ])
    |> validate_required([:name, :slug, :active, :email, :status])
    |> validate_slug(attrs)
    |> unique_constraint(:slug)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_inclusion(:status, ~w(active inactive))
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
