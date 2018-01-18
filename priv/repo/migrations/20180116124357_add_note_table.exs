defmodule Advisor.Repo.Migrations.AddNoteTable do
  use Ecto.Migration

  def up do
    create table(:notes) do
      add :note, :text
      add :advice_request_id, references(:advice_requests, type: :uuid)
    end
  end

  def down do
    drop table(:notes)
  end
end
