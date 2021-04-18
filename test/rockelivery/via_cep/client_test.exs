defmodule Rockelivery.ViaCep.ClientTest do
  use ExUnit.Case, async: true
  alias Plug.Conn
  alias Rockelivery.Error
  alias Rockelivery.ViaCep.Client

  describe "use_cep_info/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when all parameters are valid, validates the cep", %{bypass: bypass} do
      cep = "01001000"

      body = ~s({
        "cep": "01001-000",
        "logradouro": "Praça da Sé",
        "complemento": "lado ímpar",
        "bairro": "Sé",
        "localidade": "São Paulo",
        "uf": "SP",
        "ibge": "3550308",
        "gia": "1004",
        "ddd": "11",
        "siafi": "7107"
      })

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "/#{cep}/json/", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.use_cep_info(url, cep)

      expected_response =
        {:ok,
         %{
           "bairro" => "Sé",
           "cep" => "01001-000",
           "complemento" => "lado ímpar",
           "ddd" => "11",
           "gia" => "1004",
           "ibge" => "3550308",
           "localidade" => "São Paulo",
           "logradouro" => "Praça da Sé",
           "siafi" => "7107",
           "uf" => "SP"
         }}

      assert response == expected_response
    end

    test "when the cep is invalid, returns an error", %{bypass: bypass} do
      cep = "789"

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "/#{cep}/json/", fn conn ->
        Conn.resp(conn, 400, "")
      end)

      response = Client.use_cep_info(url, cep)

      expected_response =
        {:error, %Rockelivery.Error{result: "Invalid CEP!", status: :bad_request}}

      assert response == expected_response
    end

    test "when the cep could not be found but it is on the correct format, returns a not found error",
         %{bypass: bypass} do
      cep = "39403822"

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "/#{cep}/json/", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, ~s({ "erro": true }))
      end)

      response = Client.use_cep_info(url, cep)

      expected_response =
        {:error, %Rockelivery.Error{result: "CEP not found!", status: :not_found}}

      assert response == expected_response
    end

    test "when passing the server is down or for some other reason the connection could not be stablished, returns an error",
         %{bypass: bypass} do
      cep = "39403822"
      url = endpoint_url(bypass.port)

      Bypass.down(bypass)

      response = Client.use_cep_info(url, cep)

      expected_response =
        {:error, %Rockelivery.Error{result: :econnrefused, status: :bad_request}}

      assert response == expected_response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}/"
  end
end
