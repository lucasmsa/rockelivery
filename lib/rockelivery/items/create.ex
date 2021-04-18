defmodule Rockelivery.Items.Create do
  alias Rockelivery.{Error, Item, Repo}

  def call(params) do
    params
    |> Item.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, _item} = result), do: result

  defp handle_insert({:error, reason}) do
    {:error, Error.build(:bad_request, reason)}
  end
end
