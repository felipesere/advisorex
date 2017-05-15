defmodule Advisor.Repo.Migrations.RenameAdviceRequestIdToQuestionnaireId do
  use Ecto.Migration

  def change do
    rename table(:advice_requests), :advice_request_id, to: :questionnaire_id
  end
end
