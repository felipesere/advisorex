defmodule Advisor.Repo.Migrations.AddNoteTable do
  use Ecto.Migration

  def up do
    create table(:notes, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :note, :text
    end
  end

  def down do
    drop table(:notes)
  end
end
