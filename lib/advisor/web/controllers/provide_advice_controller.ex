defmodule Advisor.Web.ProvideAdviceController do
  use Advisor.Web, :controller
  alias Advisor.Core.{AdvisoryFinder, People, QuestionnaireFinder, QuestionFinder, Answer}
  alias Advisor.Repo

  def index(conn, %{"id" => id}) do
    advice_request = AdvisoryFinder.find(id)
    questionnaire = QuestionnaireFinder.find(advice_request.questionnaire_id)
    questions = QuestionFinder.find_all(questionnaire.question_ids)
    requester = People.find_by(id: advice_request.requester_id) 
    render conn, "advice-form.html", requester: requester, questions: questions, advice_id: id
  end

  def create(conn, params) do
    Repo.insert_all(Answer, all_answers(params), returning: true)
    render conn, "thank-you.html"
  end

  def all_answers(params) do
    %{"id" => advice_request_id} = params

    Enum.reduce(params, [], fn({question_id, answer}, acc) -> 
      case Integer.parse(question_id) do
        {id, ""} -> acc ++ [
          %{question_id: id,
            answer: answer,
            advice_request_id: advice_request_id,
            inserted_at: DateTime.utc_now}
        ]
        _ -> acc
      end
    end)
  end
end
