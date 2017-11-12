defmodule DB.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :game_id, references(:games, on_delete: :delete_all)
      add :status, :string, null: false
      add :is_human, :boolean, null: false
      add :stats,  :map

      timestamps()
    end

    create index(:players, :user_id)
    create index(:players, :game_id)
  end
end
