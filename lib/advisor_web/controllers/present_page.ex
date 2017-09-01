defmodule AdvisorWeb.PresentPage do
  use AdvisorWeb, :controller
  alias Advisor.Core.{People, Questions, Questionnaire, Advice, Answers}

  # TODO: This bit here is attrociously long...
  def index(conn, %{"id" => questionnaire_id}) do
    %{question_ids: question_ids} = questionnaire = Questionnaire.find(questionnaire_id)
    advisories = Advice.all_for(questionnaire_id)
    advisor_for = for advisory <- advisories, into: %{}, do: {advisory.id, People.find_by(advisory)}
    answers = Enum.flat_map(advisories, &Answers.find/1)
    questions = Questions.load(question_ids)

    answered_questions = Enum.map(questions, fn(question) ->
      answers = answers
          |> Enum.filter(fn(answer) -> question.id == answer.question_id end)
          |> Enum.map(fn(answer) -> %{
            person: advisor_for[answer.advice_request_id],
            answer_phrase: answer.answer}
          end)

      %{question_phrase: question.phrase, answers: answers}
    end)

    requester = People.requester(questionnaire)
    render conn, "index.html", id: questionnaire_id,
                               request: requester,
                               answered_questions: answered_questions
  end
end
