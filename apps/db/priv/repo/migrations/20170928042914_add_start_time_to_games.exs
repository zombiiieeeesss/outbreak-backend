defmodule DB.Repo.Migrations.AddStartTimeToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :start_time, :utc_datetime, null: false
    end
  end
end
