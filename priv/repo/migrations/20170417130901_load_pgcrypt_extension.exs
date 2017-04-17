defmodule Advisor.Repo.Migrations.LoadPgcryptExtension do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto "
  end

  def down do
    execute "DROP EXTENSION pgcrypto"
  end
end
