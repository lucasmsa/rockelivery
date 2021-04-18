defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo
  alias Rockelivery.User

  def user_params_factory() do
    %{
      "age" => 30,
      "cep" => "58038290",
      "cpf" => "12345678910",
      "name" => "banano",
      "email" => "banano@telli.com",
      "password" => "bananao",
      "address" => "rua bananona"
    }
  end

  def cep_info_factory() do
    %{
      cep: "58038-290",
      logradouro: "Rua Major Ciraulo",
      complemento: "até 621/622",
      bairro: "Manaíra",
      localidade: "João Pessoa",
      uf: "PB",
      ibge: "2507507",
      gia: "",
      ddd: "83",
      siafi: "2051"
    }
  end

  def user_factory() do
    %User{
      age: 30,
      cep: "12345678",
      cpf: "12345678910",
      name: "banano",
      email: "banano@telli.com",
      password: "bananao",
      address: "rua bananona",
      id: "c7b2235e-dab4-4141-9062-90b90e78d39a"
    }
  end
end
