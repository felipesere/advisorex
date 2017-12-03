defmodule Advisor.Repo.Migrations.RenameGroupLeadColumns do
  use Ecto.Migration

  def up do
    rename table(:questionnaires), :group_lead, to: :group_lead_id
  end

  def down do
    rename table(:questionnaires), :group_lead_id, to: :group_lead
  end
end
