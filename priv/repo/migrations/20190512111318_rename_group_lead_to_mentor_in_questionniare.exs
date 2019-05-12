defmodule Advisor.Repo.Migrations.RenameGroupLeadToMentorInQuestionniare do
  use Ecto.Migration

  def up do
    rename table(:questionnaires), :group_lead_id, to: :mentor_id
  end

  def down do
    rename table(:questionnaires), :mentor_id, to: :group_lead_id
  end
end
