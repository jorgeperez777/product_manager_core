defmodule ProductManagerCore.CatalogTest do
  use ProductManagerCore.DataCase

  alias ProductManagerCore.Catalog

  describe "providers" do
    alias ProductManagerCore.Catalog.Provider

    import ProductManagerCore.CatalogFixtures

    @invalid_attrs %{active: nil, name: nil, location: nil, slug: nil, telephone: nil, url_contact: nil, email: nil, url_image: nil}

    test "list_providers/0 returns all providers" do
      provider = provider_fixture()
      assert Catalog.list_providers() == [provider]
    end

    test "get_provider!/1 returns the provider with given id" do
      provider = provider_fixture()
      assert Catalog.get_provider!(provider.id) == provider
    end

    test "create_provider/1 with valid data creates a provider" do
      valid_attrs = %{active: true, name: "some name", location: "some location", slug: "some slug", telephone: "some telephone", url_contact: "some url_contact", email: "some email", url_image: "some url_image"}

      assert {:ok, %Provider{} = provider} = Catalog.create_provider(valid_attrs)
      assert provider.active == true
      assert provider.name == "some name"
      assert provider.location == "some location"
      assert provider.slug == "some slug"
      assert provider.telephone == "some telephone"
      assert provider.url_contact == "some url_contact"
      assert provider.email == "some email"
      assert provider.url_image == "some url_image"
    end

    test "create_provider/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_provider(@invalid_attrs)
    end

    test "update_provider/2 with valid data updates the provider" do
      provider = provider_fixture()
      update_attrs = %{active: false, name: "some updated name", location: "some updated location", slug: "some updated slug", telephone: "some updated telephone", url_contact: "some updated url_contact", email: "some updated email", url_image: "some updated url_image"}

      assert {:ok, %Provider{} = provider} = Catalog.update_provider(provider, update_attrs)
      assert provider.active == false
      assert provider.name == "some updated name"
      assert provider.location == "some updated location"
      assert provider.slug == "some updated slug"
      assert provider.telephone == "some updated telephone"
      assert provider.url_contact == "some updated url_contact"
      assert provider.email == "some updated email"
      assert provider.url_image == "some updated url_image"
    end

    test "update_provider/2 with invalid data returns error changeset" do
      provider = provider_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_provider(provider, @invalid_attrs)
      assert provider == Catalog.get_provider!(provider.id)
    end

    test "delete_provider/1 deletes the provider" do
      provider = provider_fixture()
      assert {:ok, %Provider{}} = Catalog.delete_provider(provider)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_provider!(provider.id) end
    end

    test "change_provider/1 returns a provider changeset" do
      provider = provider_fixture()
      assert %Ecto.Changeset{} = Catalog.change_provider(provider)
    end
  end

  describe "categories" do
    alias ProductManagerCore.Catalog.Category

    import ProductManagerCore.CatalogFixtures

    @invalid_attrs %{active: nil, name: nil, url_image: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Catalog.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Catalog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{active: true, name: "some name", url_image: "some url_image"}

      assert {:ok, %Category{} = category} = Catalog.create_category(valid_attrs)
      assert category.active == true
      assert category.name == "some name"
      assert category.url_image == "some url_image"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{active: false, name: "some updated name", url_image: "some updated url_image"}

      assert {:ok, %Category{} = category} = Catalog.update_category(category, update_attrs)
      assert category.active == false
      assert category.name == "some updated name"
      assert category.url_image == "some updated url_image"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_category(category, @invalid_attrs)
      assert category == Catalog.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Catalog.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Catalog.change_category(category)
    end
  end

  describe "products" do
    alias ProductManagerCore.Catalog.Product

    import ProductManagerCore.CatalogFixtures

    @invalid_attrs %{name: nil, description: nil, stock: nil, amount: nil, url_image: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{name: "some name", description: "some description", stock: 42, amount: "120.5", url_image: "some url_image"}

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.description == "some description"
      assert product.stock == 42
      assert product.amount == Decimal.new("120.5")
      assert product.url_image == "some url_image"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", stock: 43, amount: "456.7", url_image: "some updated url_image"}

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.name == "some updated name"
      assert product.description == "some updated description"
      assert product.stock == 43
      assert product.amount == Decimal.new("456.7")
      assert product.url_image == "some updated url_image"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
