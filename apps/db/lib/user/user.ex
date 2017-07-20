defmodule DB.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias DB.User

  schema "users" do
    field :email, :string
    field :password, :string

    timestamps()
  end

  @fields [:email, :password]

  def create(attrs) do
    %User{}
    |> changeset(attrs)
    |> DB.Repo.insert
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
  end
end
