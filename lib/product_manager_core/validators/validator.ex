defmodule ProductManagerCore.Validators.Validator do
  def product(params) do
    validate_params(params, &product_params/0)
  end

  def product_by_slug(params) do
    validate_params(params, &product_by_slug_params/0)
  end

  def category(params) do
    validate_params(params, &category_params/0)
  end

  def provider(params) do
    validate_params(params, &provider_params/0)
  end

  defp validate_params(params, validate_schema_fn) do
    with {:ok, validated_params} <- Tarams.cast(params, validate_schema_fn.()) do
      {:ok, validated_params}
    else
      {:error, error} -> {:error, error}
    end
  end

  defp product_params() do
    %{
      description: [type: :string, default: ""],
      stock: [type: :integer, default: 0],
      name: [type: :string, default: ""],
      size_items: [type: :string, default: ""],
      page: [type: :string, default: ""],
      active: [type: :boolean, default: false],
      slug: [type: :string],
      status_stock: [type: :string],
      status: [type: :string],
      amount: [type: :integer, default: 0],
      provider_slug: [type: :string],
      category_slug: [type: :string],
      pagination: [
        type: %{
          size: [type: :string],
          page: [type: :string]
        },
        default: %{}
      ]
    }
  end

  defp category_params() do
    %{
      name: [type: :string, default: ""],
      active: [type: :boolean, default: false],
      slug: [type: :string],
      status: [type: :string]
    }
  end

  defp product_by_slug_params() do
    %{
      slug: [type: :string, required: true]
    }
  end

  defp provider_params() do
    %{
      name: [type: :string, default: ""],
      active: [type: :boolean, default: false],
      slug: [type: :string],
      status: [type: :string],
      size_items: [type: :string, default: ""]
    }
  end
end
