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

  def get_by_email(email) do
    DB.Repo.get_by(User, email: email)
  end

  def get(id) do
    DB.Repo.get(User, id)
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
  end
end
