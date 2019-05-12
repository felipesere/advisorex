defmodule Advisor.Repo.Migrations.RenameRequesterToMenteeInQuestionnaire do
  use Ecto.Migration

  def up do
    rename table(:questionnaires), :requester_id, to: :mentee_id
  end

  def down do
    rename table(:questionnaires), :mentee_id, to: :requester_id
  end
end
