defmodule DB.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :execute_at, :integer
      add :params, :binary
      add :status, :string

      timestamps()
    end
  end
end
