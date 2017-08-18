defmodule DB.Repo.Migrations.CreateFriendship do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :requester_id, references(:users, on_delete: :delete_all)
      add :requestee_id, references(:users, on_delete: :delete_all)
      add :status, :string

      timestamps()
    end

    create unique_index(:friendships, [:requester_id, :requestee_id], name: :requester_requestee)
  end
end
