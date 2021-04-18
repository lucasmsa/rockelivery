defmodule Rockelivery.Orders.TotalPrice do
  alias Rockelivery.Item

  def call(items) do
    Enum.reduce(items, Decimal.new("0"), fn %Item{price: price}, acc ->
      Decimal.add(acc, price)
    end)
  end
end
