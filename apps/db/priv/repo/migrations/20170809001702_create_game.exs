defmodule DB.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :status, :string, null: false
      add :round, :integer
      add :round_length, :integer
      add :round_limit, :integer
      add :owner_id, :integer
      add :title, :string

      timestamps()
    end
  end
end
