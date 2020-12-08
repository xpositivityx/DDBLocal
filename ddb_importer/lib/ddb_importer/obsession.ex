defmodule DdbImporter.Obsession do
  @derive [ExAws.Dynamo.Encodable]
  defstruct [
    :user_id,
    :created_at,
    :variant_id,
    :product_id,
    :price,
    :count_on_hand,
    :on_sale,
    :designer_id,
    :taxonomy_id
  ]
end
