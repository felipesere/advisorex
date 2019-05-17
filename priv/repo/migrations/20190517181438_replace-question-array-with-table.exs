defmodule Elixir.Advisor.Repo.Migrations.ReplaceQuestionArrayWithTable do
  use Ecto.Migration
  import Ecto.Query
  alias Advisor.Repo

  def up do
    create table(:questionnaire_to_question) do
      add(:questionnaire_id, references(:questionnaires, type: :uuid, on_delete: :delete_all))
      add(:question_id,      references(:questions,      type: :uuid, on_delete: :delete_all))
    end

    flush()

    questionnaires = from(q in "questionnaires", select: [:id, :question_ids]) |> Repo.all()

    references = questionnaires
                 |> Enum.flat_map(fn q ->
                   Enum.map(q.question_ids, fn question ->
                     %{questionnaire_id: q.id, question_id: uuid(question)}
                   end)
                 end)

    Repo.insert_all("questionnaire_to_question", references)

    alter table(:questionnaires) do
      remove(:question_ids)
    end
  end

  def uuid(val) do
    {:ok, uuid} = Ecto.UUID.dump(val)
    uuid
  end
end


