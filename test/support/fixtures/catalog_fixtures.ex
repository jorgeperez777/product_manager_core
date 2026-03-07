defmodule ProductManagerCore.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ProductManagerCore.Catalog` context.
  """

  @doc """
  Generate a provider.
  """
  def provider_fixture(attrs \\ %{}) do
    {:ok, provider} =
      attrs
      |> Enum.into(%{
        active: true,
        email: "some email",
        location: "some location",
        name: "some name",
        slug: "some slug",
        telephone: "some telephone",
        url_contact: "some url_contact",
        url_image: "some url_image"
      })
      |> ProductManagerCore.Catalog.create_provider()

    provider
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        active: true,
        name: "some name",
        url_image: "some url_image"
      })
      |> ProductManagerCore.Catalog.create_category()

    category
  end

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        description: "some description",
        name: "some name",
        stock: 42,
        url_image: "some url_image"
      })
      |> ProductManagerCore.Catalog.create_product()

    product
  end
end
