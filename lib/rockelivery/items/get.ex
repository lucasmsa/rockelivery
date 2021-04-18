defmodule Rockelivery.Items.Get do
  alias Rockelivery.{Error, Item, Repo}

  def call(id) do
    case Repo.get(Item, id) do
      nil -> {:error, Error.build_item_not_found()}
      item -> {:ok, item}
    end
  end
end
