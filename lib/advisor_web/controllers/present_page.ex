defmodule AdvisorWeb.PresentPage do
  use AdvisorWeb, :controller
  alias Advisor.Core.{Questions, Questionnaire}
  alias AdvisorWeb.Authentication.User

  plug  AdvisorWeb.Authentication.Gatekeeper, only: :group_leads

  def index(conn, %{"id" => questionnaire_id}) do
    user = User.of(conn)
    questionnaire = Questionnaire.find(questionnaire_id)

    if questionnaire.group_lead == user do
      answered_questions = answers_per_question(questionnaire)
      notes = all_notes(questionnaire)

      render conn, "index.html", id: questionnaire_id,
                                 request: questionnaire.requester,
                                 answered_questions: answered_questions,
                                 notes: notes
    else
      conn |> redirect(to: "/")
    end
  end

  defp answers_per_question(questionnaire) do
    questionnaire
    |> collect_answers()
    |> join_answers(advisors(questionnaire))
    |> answered_questions(questionnaire)
  end

  defp collect_answers(%Questionnaire{advice: advisories}) do
    Enum.flat_map(advisories, &(&1.answers))
  end

  defp advisors(%Questionnaire{advice: advisories}) do
    for advice <- advisories, into: %{}, do: {advice.id, advice.advisor}
  end

  defp join_answers(answers, advisors) do
    answers
    |> Enum.map(fn(answer) ->
      %{
        question_id: answer.question_id,
        answer_phrase: answer.answer,
        person: advisors[answer.advice_request_id]
      }
    end)
  end

  defp answered_questions(answers, %Questionnaire{question_ids: question_ids}) do
    questions = Questions.load(question_ids)

    answers
    |> Enum.group_by(&(&1.question_id), &(&1))
    |> Enum.map(fn({question_id, answers}) ->
      question = Enum.find(questions, &(&1.id == question_id))
      %{
        question_phrase: question.phrase,
        answers: answers
      }
    end)
  end

  defp all_notes(questionnaire) do
    collect_notes(questionnaire)
    |> join_notes(advisors(questionnaire))
  end

  defp collect_notes(%Questionnaire{advice: advisories}) do
    advisories
    |> Enum.map(&(&1.note))
    |> Enum.reject(&is_nil/1)
  end

  defp join_notes(notes, advisors) do
    notes
    |> Enum.map(fn(note) ->
      %{note_phrase: note.note,
        person: advisors[note.advice_request_id]}
    end)
  end
end
