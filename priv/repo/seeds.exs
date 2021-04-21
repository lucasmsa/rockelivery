# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rockelivery.Repo.insert!(%Rockelivery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rockelivery.{User, Item, Order, Repo}

user = %User{
  age: 19,
  address: "rua bananona",
  cep: "58039280",
  email: "bana@no.com",
  cpf: "82038003476",
  name: "Batatao",
  password: "123456"
}

%User{id: user_id} = Repo.insert!(user)

item = %Item{
  category: :drink,
  description: "suco de banana",
  photo: "suco_de_banana.png",
  price: Decimal.new("10.0")
}

%Item{id: item_id} = Repo.insert!(item)

order = %Order{
  user_id: user_id,
  items: [item, item],
  address: "Rua batatona, 20",
  payment: :money,
  comments: "sem banana"
}

Repo.insert!(order)
