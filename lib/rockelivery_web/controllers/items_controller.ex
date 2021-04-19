defmodule RockeliveryWeb.ItemsController do
  use RockeliveryWeb, :controller
  alias Rockelivery.Item
  alias RockeliveryWeb.FallbackController

  action_fallback(FallbackController)

  def create(conn, params) do
    with {:ok, %Item{} = item} <- Rockelivery.create_item(params) do
      conn
      |> put_status(:created)
      |> render("create.json", item: item)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Item{} = item} <- Rockelivery.get_item(id) do
      conn
      |> put_status(:ok)
      |> render("item.json", item: item)
    end
  end

  def update(conn, params) do
    with {:ok, %Item{} = item} <- Rockelivery.update_item(params) do
      conn
      |> put_status(:ok)
      |> render("item.json", item: item)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Item{}} <- Rockelivery.delete_item(id) do
      conn
      |> put_status(:no_content)
      |> text("")
    end
  end
end
