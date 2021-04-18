defmodule Rockelivery.Users.CreateTest do
  use Rockelivery.DataCase, async: true
  alias Rockelivery.Error
  alias Rockelivery.User
  alias Rockelivery.Users.Create
  import Rockelivery.Factory
  alias Rockelivery.ViaCep.ClientMock
  import Mox

  describe "call/1" do
    test "If it receives the right parameters, creates a new user" do
      expect(ClientMock, :use_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      response = Create.call(build(:user_params, %{"name" => "Nelson"}))

      assert {:ok, %User{name: "Nelson"}} = response
    end

    test "If some parameter is wrong, returns an error" do
      user = build(:user_params, %{"age" => 10, "cpf" => "banane"})

      assert {:error, %Error{status: :bad_request, result: response}} = Create.call(user)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        cpf: ["should be 11 character(s)"]
      }

      assert expected_response == errors_on(response)
    end
  end
end
