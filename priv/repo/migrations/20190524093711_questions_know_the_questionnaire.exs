defmodule Advisor.Repo.Migrations.QuestionsKnowTheQuestionnaire do
  use Ecto.Migration
  import Ecto.Query
  alias Advisor.Repo

  def up do
    alter table(:questions) do
      add(:questionnaire_id, references(:questionnaires, type: :uuid, on_delete: :delete_all))
    end

    flush()

    relations =
      from(q in "questionnaire_to_question", select: [:questionnaire_id, :question_id])
      |> Repo.all()

    from(q in "questions", select: [:id])
    |> Repo.all()
    |> Enum.map(fn %{id: question_id} ->
      %{questionnaire_id: questionnaire_id} = Enum.find(relations, fn (%{question_id: id}) -> id == question_id end)

      from( q in "questions", where: q.id == ^question_id, update: [set: [questionnaire_id: ^questionnaire_id]])
      |> Repo.update_all([])
     end)


    drop table(:questionnaire_to_question)
  end

  def down do
    create table(:questionnaire_to_question) do
      add(:questionnaire_id, references(:questionnaires, type: :uuid, on_delete: :delete_all))
      add(:question_id,      references(:questions,      type: :uuid, on_delete: :delete_all))
    end

    flush()

    questions =
      from(q in "questions", select: [:id, :questionnaire_id])
      |> Repo.all()
      |> Enum.map(fn %{id: i, questionnaire_id: qid} -> %{question_id: i, questionnaire_id: qid}  end)

    Repo.insert_all("questionnaire_to_question", questions)

    alter table(:questions) do
      remove :questionnaire_id
    end

  end
end
