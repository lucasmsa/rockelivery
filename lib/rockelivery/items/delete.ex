defmodule Rockelivery.Items.Delete do
  alias Rockelivery.{Error, Item, Repo}

  def call(id) do
    case Repo.get(Item, id) do
      nil -> {:error, Error.build_item_not_found()}
      item -> Repo.delete(item)
    end
  end
end
