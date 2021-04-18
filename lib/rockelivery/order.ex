defmodule Rockelivery.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rockelivery.{Item, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_params [:address, :comments, :payment, :user_id]
  @valid_methods [:money, :credit_card, :debit_card]
  @derive {Jason.Encoder, only: @required_params ++ [:id, :items]}

  schema "orders" do
    field(:address, :string)
    field(:comments, :string)
    field(:payment, Ecto.Enum, values: @valid_methods)

    many_to_many :items, Item, join_through: "ordersItems"
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params, items) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> put_assoc(:items, items)
    |> validate_length(:address, min: 10)
    |> validate_length(:comments, min: 10)
  end
end
