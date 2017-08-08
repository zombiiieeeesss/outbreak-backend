defmodule API.GuardianSerializer do
  @moduledoc false

  @behaviour Guardian.Serializer

  def for_token(user = %DB.User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, DB.User.get(id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
