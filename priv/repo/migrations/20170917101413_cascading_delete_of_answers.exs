defmodule Advisor.Repo.Migrations.CascadingDeleteOfAnswers do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE answers DROP CONSTRAINT answers_advice_request_id_fkey"
    alter table("answers") do
      modify :advice_request_id, references("advice_requests",
                                            type: :binary_id,
                                            on_delete: :delete_all)
    end
  end
end
