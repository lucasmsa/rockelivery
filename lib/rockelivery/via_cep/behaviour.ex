defmodule Rockelivery.ViaCep.Behaviour do
  alias Rockelivery.Error

  @callback use_cep_info(String.t()) :: {:ok, map()} | {:error, Error.t()}
end
