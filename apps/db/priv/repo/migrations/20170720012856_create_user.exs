defmodule DB.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email,    :string, null: false
      add :encrypted_password, :string, null: false

      timestamps()
    end

    create unique_index(:users, ["lower(username)"], name: :lowercase_username)
    create unique_index(:users, ["lower(email)"], name: :lowercase_email)

    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX users_username_trgm_index ON users USING gin (username gin_trgm_ops);"
    execute "CREATE INDEX users_email_trgm_index ON users USING gin (email gin_trgm_ops);"
  end
end
