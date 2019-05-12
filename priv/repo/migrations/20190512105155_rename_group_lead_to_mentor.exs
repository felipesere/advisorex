defmodule Advisor.Repo.Migrations.RenameGroupLeadToMentor do
  use Ecto.Migration

  def up do
    rename table(:people), :is_group_lead, to: :is_mentor
  end

  def down do
    rename table(:people), :is_mentor, to: :is_group_lead
  end
end
