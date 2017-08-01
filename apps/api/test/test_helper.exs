ExUnit.start()

defmodule API.Web.Controller.TestHelper do
  def json_response(res) do
    res.resp_body
    |> Poison.decode!
    |> Map.new(&string_to_atom_keys/1)
  end

  def response_headers(res) do
    res.resp_headers
    |> Enum.into(%{})
  end

  defp string_to_atom_keys({k, v}) when is_map(v) do
    {String.to_atom(k), Map.new(v, &string_to_atom_keys/1)}
  end
  defp string_to_atom_keys({k, v}), do: {String.to_atom(k), v}
end
