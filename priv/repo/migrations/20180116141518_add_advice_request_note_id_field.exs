defmodule Advisor.Repo.Migrations.AddAdviceRequestNoteIdField do
  use Ecto.Migration

  def up do
    alter table(:advice_requests) do
      add :note_id, :uuid, null: true
    end
  end

  def down do
    alter table(:advice_requests) do
      remove :note_id
    end
  end
end
