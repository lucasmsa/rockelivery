defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true
  import Rockelivery.Factory
  alias Rockelivery.ViaCep.ClientMock
  alias RockeliveryWeb.Auth.Guardian
  import Mox

  describe "create/2" do
    test "When all parameters are valid creates the user", %{conn: conn} do
      params = %{
        "age" => 30,
        "cep" => "58038290",
        "cpf" => "12345678910",
        "name" => "banano",
        "email" => "banano@telli.com",
        "password" => "bananao",
        "address" => "rua bananona"
      }

      expect(ClientMock, :use_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      expected_response = %{
        "message" => "User created 🍇",
        "user" => %{
          "age" => 30,
          "name" => "banano",
          "email" => "banano@telli.com"
        }
      }

      assert expected_response = response
    end

    test "Returns an error if some parameter(s) is/are invalid", %{conn: conn} do
      params = %{
        "age" => 10,
        "cep" => "12345678",
        "cpf" => "12345678910",
        "name" => "banano",
        "email" => "banano@telli.com",
        "password" => "bananao",
        "address" => "rua bananona"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"age" => ["must be greater than or equal to 18"]}}
      assert expected_response == response
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn, user: user}
    end

    test "Deletes an user if he/she exists", %{conn: conn, user: user} do
      id = "c7b2235e-dab4-4141-9062-90b90e78d39a"

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      assert "" == response
    end

    test "Returns an error if the user doesn't exist", %{conn: conn} do
      id = "c7b2235e-dab4-4141-9062-90b90e78d39b"

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:not_found)

      assert %{"message" => "User not found! 🥷🏻"} == response
    end
  end
end
