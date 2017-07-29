ExUnit.start()

defmodule API.Web.Controller.TestHelper do
  def json_response(res) do
    res.resp_body
    |> Poison.decode!
    |> Map.new(fn({k,v}) -> {String.to_atom(k), v} end)
  end
end
