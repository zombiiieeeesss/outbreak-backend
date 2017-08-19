defmodule DB.Repo.Migrations.CreateFriendRequest do
  use Ecto.Migration

  def change do
    create table(:friend_requests) do
      add :requester_id, references(:users, on_delete: :delete_all)
      add :requestee_id, references(:users, on_delete: :delete_all)
      add :status, :string

      timestamps()
    end

    create unique_index(:friend_requests, [:requester_id, :requestee_id], name: :requester_requestee)
  end
end
