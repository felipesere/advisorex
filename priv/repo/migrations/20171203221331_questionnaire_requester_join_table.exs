defmodule Advisor.Repo.Migrations.QuestionnaireRequesterJoinTable do
  use Ecto.Migration

  def up do
    create table(:questionnaire_to_requester, primary_key: false) do
      add :questionnaire_id, :uuid, null: false
      add :requester_id, :integer, null: false
    end
  end

  def down do
    drop table(:questionnaire_to_requester)
  end
end
