defmodule RockeliveryWeb.UsersViewTest do
  use RockeliveryWeb.ConnCase, async: true
  alias RockeliveryWeb.UsersView
  import Phoenix.View
  import Rockelivery.Factory

  test "Shows the user" do
    user = build(:user)
    token = "abcde"
    response = render(UsersView, "create.json", token: token, user: user)

    assert %{
             message: "User created 🍇",
             token: "abcde",
             user: %Rockelivery.User{
               address: "rua bananona",
               age: 30,
               cep: "12345678",
               cpf: "12345678910",
               email: "banano@telli.com",
               id: "c7b2235e-dab4-4141-9062-90b90e78d39a",
               name: "banano",
               password: "bananao"
             }
           } = response
  end
end
