defmodule Advisor.Repo.Migrations.RenameAdviceRequestIdOnAnswers do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE answers DROP CONSTRAINT answers_advice_request_id_fkey"
    rename table(:answers), :advice_request_id, to: :advice_id

    alter table(:answers) do
      modify :advice_id, references(:advice, column: :id, type: :uuid, on_delete: :delete_all)
    end
  end

  def down do
    execute "ALTER TABLE answers DROP CONSTRAINT answers_advice_id_fkey"
    rename table(:answers), :advice_id, to: :advice_request_id

    alter table(:answers) do
      modify :advice_request_id, references(:advice, column: :id, type: :uuid, on_delete: :delete_all)
    end
  end
end
