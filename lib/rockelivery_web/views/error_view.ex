defmodule RockeliveryWeb.ErrorView do
  use RockeliveryWeb, :view
  alias Ecto.Changeset

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("error.json", %{result: %Changeset{} = result}) do
    %{message: translate_errors(result)}
  end

  def render("error.json", %{result: result}) do
    %{message: result}
  end

  def translate_errors(%Changeset{} = changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", translate_value(value))
      end)
    end)
  end

  def translate_value({:parameterized, Ecto.Enum, _map}), do: ""

  def translate_value(value), do: to_string(value)
end
