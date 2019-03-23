defmodule Advisor.Repo.Migrations.AddGroupLoadToQuestionnaire do
  use Ecto.Migration

  def up do
    alter table(:questionnaires) do
      add(:group_lead, :integer)
    end
  end

  def down do
    alter table(:questionnaires) do
      remove(:group_lead)
    end
  end
end
