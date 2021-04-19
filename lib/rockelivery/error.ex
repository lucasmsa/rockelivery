defmodule Rockelivery.Error do
  @keys [:status, :result]
  @enforce_keys @keys
  defstruct @keys

  def build(status, result) do
    %__MODULE__{
      status: status,
      result: result
    }
  end

  def build_user_not_found, do: build(:not_found, "User not found! 🥷🏻")
  def build_item_not_found, do: build(:not_found, "Item not found! 🌵")
end
