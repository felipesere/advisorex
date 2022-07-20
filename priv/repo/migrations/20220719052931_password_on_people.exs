defmodule Advisor.Repo.Migrations.PasswordOnPeople do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    alter table(:people) do
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()

      modify :email, :citext
    end
  end
end
