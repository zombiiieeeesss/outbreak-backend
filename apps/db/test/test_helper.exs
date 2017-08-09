ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(DB.Repo, :manual)

defmodule DB.Model.TestHelper do
  def is_valid(%Ecto.Changeset{valid?: valid}), do: valid
end
