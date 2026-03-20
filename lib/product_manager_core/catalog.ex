defmodule ProductManagerCore.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias ProductManagerCore.Repo

  alias ProductManagerCore.Catalog.Provider

  @doc """
  Returns the list of providers.

  ## Examples

      iex> list_providers()
      [%Provider{}, ...]

  """
  def list_providers do
    Repo.all(Provider)
  end

  def list_providers(args) do
    from(q in Provider,
      order_by: [desc: q.inserted_at]
    )
    |> apply_filters(args)
    |> Repo.all()
  end

  defp apply_filters(query, opts) do
    Enum.reduce(opts, query, fn
      {:active, active}, query ->
        from q in query, where: q.active == ^active

      _, query ->
        query
    end)
  end

  @doc """
  Gets a single provider.

  Raises `Ecto.NoResultsError` if the Provider does not exist.

  ## Examples

      iex> get_provider!(123)
      %Provider{}

      iex> get_provider!(456)
      ** (Ecto.NoResultsError)

  """
  def get_provider!(id), do: Repo.get!(Provider, id)

  @doc """
  Creates a provider.

  ## Examples

      iex> create_provider(%{field: value})
      {:ok, %Provider{}}

      iex> create_provider(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_provider(attrs \\ %{}) do
    %Provider{}
    |> Provider.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a provider.

  ## Examples

      iex> update_provider(provider, %{field: new_value})
      {:ok, %Provider{}}

      iex> update_provider(provider, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_provider(%Provider{} = provider, attrs) do
    provider
    |> Provider.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a provider.

  ## Examples

      iex> delete_provider(provider)
      {:ok, %Provider{}}

      iex> delete_provider(provider)
      {:error, %Ecto.Changeset{}}

  """
  def delete_provider(%Provider{} = provider) do
    Repo.delete(provider)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking provider changes.

  ## Examples

      iex> change_provider(provider)
      %Ecto.Changeset{data: %Provider{}}

  """
  def change_provider(%Provider{} = provider, attrs \\ %{}) do
    Provider.changeset(provider, attrs)
  end

  alias ProductManagerCore.Catalog.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  def list_categories(args) do
    from(q in Category,
      order_by: [desc: q.inserted_at]
    )
    |> apply_filters_category(args)
    |> Repo.all()
  end

  defp apply_filters_category(query, opts) do
    Enum.reduce(opts, query, fn
      {:active, active}, query ->
        from q in query, where: q.active == ^active

      _, query ->
        query
    end)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  alias ProductManagerCore.Catalog.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product) |> Repo.preload([:categories, :provider])
  end

  def list_products(args) do
    from(q in Product,
      order_by: [desc: q.inserted_at]
    )
    |> apply_product_filters(args)
    |> Repo.all()
    |> Repo.preload([:categories, :provider])
  end

  defp apply_product_filters(query, opts) do
    Enum.reduce(opts, query, fn
      {:active, active}, query ->
        from q in query, where: q.active == ^active

      {:pagination, pagination}, query ->
        pagination =
          Map.has_key?(pagination, :size)
          |> case do
            true ->
              %{
                size:
                  case pagination.size do
                    nil -> nil
                    _ -> String.to_integer(pagination.size)
                  end,
                page:
                  case pagination.size do
                    nil -> nil
                    _ -> String.to_integer(pagination.page)
                  end
              }

            _ ->
              pagination
          end

        if map_size(pagination) > 0 do
          if !is_nil(pagination.size) and !is_nil(pagination.page) do
            from(q in query,
              limit: ^pagination.size,
              offset: ^((pagination.page - 1) * pagination.size)
            )
          else
            query
          end
        else
          query
        end

      {:size_items, size_items}, query ->
        if size_items != "" do
          size_items_converter =
            case size_items do
              nil -> nil
              _ -> String.to_integer(size_items)
            end

          if !is_nil(size_items_converter) do
            from(q in query,
              limit: ^size_items_converter
            )
          else
            query
          end
        else
          query
        end

      {:page, page}, query ->
        if page != "" do
          page_converter =
            case page do
              nil -> nil
              _ -> String.to_integer(page)
            end

          size_items = Map.get(opts, :size_items, nil)

          size_items_converter =
            case size_items do
              nil -> nil
              _ -> String.to_integer(size_items)
            end

          # IO.inspect(opts)

          if !is_nil(page_converter) and !is_nil(size_items_converter) do
            from(q in query,
              offset: ^((page_converter - 1) * size_items_converter)
            )
          else
            query
          end
        else
          query
        end

      {:name, name}, query ->
        if name != "" do
          from(q in query,
            where:
              fragment(
                "translate(?,'áéíóúÁÉÍÓÚçÇüÜ', 'aeiouAEIOUcCuU') ILIKE translate(?,'áéíóúÁÉÍÓÚçÇüÜ', 'aeiouAEIOUcCuU')",
                q.name,
                ^"%#{name}%"
              )
          )
        else
          query
        end

      _, query ->
        query
    end)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id) |> Repo.preload([:categories, :provider])

  def get_product_by_slug!(slug),
    do: Repo.get_by!(Product, slug: slug) |> Repo.preload([:categories])

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> put_categories(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Repo.preload(:categories)
    |> Product.changeset(attrs)
    |> put_categories(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    product
    |> Product.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:categories, product.categories)
  end

  defp put_categories(changeset, %{"category_ids" => category_ids}) do
    ids =
      category_ids
      |> Enum.flat_map(fn id ->
        case Integer.parse(to_string(id)) do
          {int, _} -> [int]
          :error -> []
        end
      end)

    categories = Repo.all(from c in Category, where: c.id in ^ids)
    Ecto.Changeset.put_assoc(changeset, :categories, categories)
  end

  # defp put_categories(changeset, %{"category_ids" => category_ids})
  #      when is_list(category_ids) do
  #   categories = Repo.all(from c in Category, where: c.id in ^category_ids)
  #   Ecto.Changeset.put_assoc(changeset, :categories, categories)
  # end

  defp put_categories(changeset, _attrs), do: changeset
end
