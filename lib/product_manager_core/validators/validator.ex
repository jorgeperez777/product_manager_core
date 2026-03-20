defmodule ProductManagerCore.Validators.Validator do
  def product(params) do
    validate_params(params, &product_params/0)
  end

  def product_by_slug(params) do
    validate_params(params, &product_by_slug_params/0)
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
      pagination: [
        type: %{
          size: [type: :string],
          page: [type: :string]
        },
        default: %{}
      ]
    }
  end

  defp product_by_slug_params() do
    %{
      slug: [type: :string, required: true]
    }
  end
end
