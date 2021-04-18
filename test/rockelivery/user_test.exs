defmodule Rockelivery.UsersTest do
  use Rockelivery.DataCase, async: true
  alias Ecto.Changeset
  alias Rockelivery.User
  import Rockelivery.Factory

  describe "changeset/2" do
    test "When all parameters are valid, returns a valid changeset" do
      params = build(:user_params)

      response = User.changeset(params)
      assert %Changeset{changes: %{name: "banano"}, valid?: true} = response
    end

    test "When updating an user, returns a valid changeset" do
      params = build(:user_params)

      changeset = User.changeset(params)

      update_params = %{
        "name" => "bananerson",
        "password" => "bananao"
      }

      response = User.changeset(changeset, update_params)
      assert %Changeset{changes: %{name: "bananerson"}, valid?: true} = response
    end

    test "If there are any errors in the params, returns an error" do
      params = build(:user_params, %{"age" => 6, "password" => "bike"})

      response = User.changeset(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert expected_response == errors_on(response)
    end
  end
end
