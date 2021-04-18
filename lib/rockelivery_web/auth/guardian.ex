defmodule RockeliveryWeb.Auth.Guardian do
  use Guardian, otp_app: :rockelivery
  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Get, as: UsersGet

  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> UsersGet.by_id()
  end

  def authenticate(%{"id" => user_id, "password" => password}) do
    with {:ok, user} <- UsersGet.by_id(user_id),
         true <- Pbkdf2.verify_pass(password, user.password_hash),
         {:ok, token, _claims} <- encode_and_sign(user) do
      {:ok, token}
    else
      false -> {:error, Error.build(:unauthorized, "Password does not match")}
      error -> error
    end
  end

  def authenticate(_params), do: {:error, Error.build(:bad_request, "Invalid parameters")}
end
