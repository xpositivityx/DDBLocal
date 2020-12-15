defmodule DdbImporter do
  @moduledoc """
  Documentation for `DdbImporter`.
  """
  alias ExAws.Dynamo
  alias DdbImporter.Obsession

  NimbleCSV.define(Parser, separator: ",", escape: "\"")
  @doc """
  """
  def csv_to_ddb(path) do
    path
    |> File.stream!
    |> Parser.parse_stream
    |> Enum.each(&DdbImporter.put_record(&1))
    |> Stream.run
  end
  @doc """
    query_opts() :: [
    consistent_read: boolean(),
    exclusive_start_key: exclusive_start_key_vals(),
    expression_attribute_names: expression_attribute_names_vals(),
    expression_attribute_values: expression_attribute_values_vals(),
    filter_expression: binary(),
    index_name: binary(),
    key_condition_expression: binary(),
    limit: pos_integer(),
    projection_expression: binary(),
    return_consumed_capacity: return_consumed_capacity_vals(),
    scan_index_forward: boolean(),
    select: select_vals()

    Dynamo.query("Obsessions", opts)
    ]
  """
  def obsessions_for_user_by_date(user_id) do
    IO.puts(user_id)
    Dynamo.query("Obsessions",
    expression_attribute_values: [user_id: "#{user_id}"],
    key_condition_expression: "user_id = :user_id",
    scan_index_forward: false,
    return_consumed_capacity: "TOTAL")
    |> ExAws.request!
    |> print_consumed_capacity
    |> Dynamo.decode_item(as: Obsession)
    |> IO.inspect
  end

  @doc """
    scan_opts() :: [
      exclusive_start_key: exclusive_start_key_vals(),
      expression_attribute_names: expression_attribute_names_vals(),
      expression_attribute_values: expression_attribute_values_vals(),
      filter_expression: binary(),
      index_name: binary(),
      limit: pos_integer(),
      projection_expression: binary(),
      return_consumed_capacity: return_consumed_capacity_vals(),
      segment: non_neg_integer(),
      select: select_vals(),
      total_segments: pos_integer()
    ]

    Dynamo.scan("Obsessions", opts)
    ]
  """
  def products_obsessed?(user_id) do
    product_ids = []
    Dynamo.query("Obsessions",
    expression_attribute_values: [user_id: user_id],
    key_condition_expression: "user_id = :user_id",
    filter_expression: "product_id IN (#{product_ids})",
    projection_expression: "product_id, user_id",
    return_consumed_capacity: "TOTAL")
    |> ExAws.request!
    |> print_consumed_capacity
    |> IO.inspect
    |> Dynamo.decode_item(as: Obsession)
    |> IO.inspect
  end

  def put_record([
    user_id,
    created_at,
    variant_id,
    product_id,
    price,
    count_on_hand,
    on_sale,
    designer_id,
    taxonomy_id
  ]) do
    obsession = %Obsession{
      user_id: user_id,
      created_at: created_at,
      variant_id: variant_id,
      product_id: product_id,
      price: price,
      count_on_hand: count_on_hand,
      on_sale: on_sale,
      designer_id: designer_id,
      taxonomy_id: taxonomy_id
    }
    Dynamo.put_item("Obsessions", obsession) |> ExAws.request!
  end

  def print_consumed_capacity(obj) do
    units = obj["ConsumedCapacity"]["CapacityUnits"]
    IO.puts("Used Capacity Units: #{units}")
    obj
  end
end
