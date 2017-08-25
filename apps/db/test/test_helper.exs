ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(DB.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)

defmodule DB.Model.TestHelper do
  def is_valid(%Ecto.Changeset{valid?: valid}), do: valid
end
