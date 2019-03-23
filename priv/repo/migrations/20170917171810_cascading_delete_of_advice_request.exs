defmodule Advisor.Repo.Migrations.CascadingDeleteOfAdviceRequest do
  use Ecto.Migration

  def up do
    alter table(:advice_requests) do
      remove(:questionnaire_id)
    end

    flush()

    alter table(:advice_requests) do
      add(
        :questionnaire_id,
        references(:questionnaires,
          type: :binary_id,
          on_delete: :delete_all
        )
      )
    end
  end
end
