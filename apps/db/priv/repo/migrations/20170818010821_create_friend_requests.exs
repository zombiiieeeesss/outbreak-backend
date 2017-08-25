defmodule DB.Repo.Migrations.CreateFriendRequest do
  use Ecto.Migration

  def change do
    create table(:friend_requests) do
      add :requesting_user_id, references(:users, on_delete: :delete_all)
      add :requested_user_id, references(:users, on_delete: :delete_all)
      add :status, :string

      timestamps()
    end

    create unique_index(:friend_requests, ["greatest(requesting_user_id,requested_user_id)", "least(requesting_user_id,requested_user_id)"], name: :requester_requestee)
  end
end
