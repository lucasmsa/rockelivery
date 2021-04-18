defmodule Rockelivery.Items.Update do
  alias Rockelivery.{Error, Item, Repo}

  def call(%{"id" => id} = params) do
    case Repo.get(Item, id) do
      nil -> {:error, Error.build_item_not_found()}
      item -> do_update(item, params)
    end
  end

  defp do_update(item, params) do
    item
    |> Item.changeset(params)
    |> Repo.update()
  end
end
