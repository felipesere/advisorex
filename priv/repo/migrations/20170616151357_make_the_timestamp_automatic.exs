defmodule Advisor.Repo.Migrations.MakeTheTimestampAutomatic do
  use Ecto.Migration

  def up do
    alter table(:answers) do
      modify(:inserted_at, :utc_datetime, default: fragment("NOW()"))
    end
  end

  def down do
    alter table(:answers) do
      modify(:inserted_at, :utc_datetime, default: nil)
    end
  end
end
