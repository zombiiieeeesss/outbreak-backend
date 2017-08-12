defmodule DB.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :user_id, references(:users)
      add :game_id, references(:games)

      timestamps()
    end
  end
end
