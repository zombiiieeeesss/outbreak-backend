ExUnit.start()
{:ok, _} = Application.ensure_all_started(:ex_machina)

defmodule API.Web.Controller.TestHelper do
  def json_response(res) do
    res.resp_body
    |> Poison.decode!
    |> string_to_atom_keys
  end

  def response_headers(res) do
    res.resp_headers
    |> Enum.into(%{})
  end

  defp string_to_atom_keys({k, v}) when is_list(v) do
    {String.to_atom(k), Enum.map(v, &string_to_atom_keys/1)}
  end
  defp string_to_atom_keys({k, v}) when is_map(v) do
    {String.to_atom(k), Map.new(v, &string_to_atom_keys/1)}
  end
  defp string_to_atom_keys({k, v}), do: {String.to_atom(k), v}
  defp string_to_atom_keys(v) when is_list(v) do
    Enum.map(v, &string_to_atom_keys/1)
  end
  defp string_to_atom_keys(v) when is_map(v) do
    Map.new(v, &string_to_atom_keys/1)
  end
  defp string_to_atom_keys(v), do: v
end
