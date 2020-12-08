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
      obsession_id: user_id,
      created_at: created_at,
      variant_id: variant_id,
      product_id: product_id,
      price: price,
      count_on_hand: count_on_hand,
      on_sale: on_sale,
      designer_id: designer_id,
      taxonomy_id: taxonomy_id
    }
    IO.puts("Putting..")
    IO.inspect(obsession)
    Dynamo.put_item("Obsessions", obsession) |> ExAws.request!
  end
end
