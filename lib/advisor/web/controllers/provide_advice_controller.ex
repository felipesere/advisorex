defmodule Advisor.Web.ProvideAdviceController do
  use Advisor.Web, :controller
  alias Advisor.Core.{AdvisoryFinder, People, QuestionnaireFinder, QuestionFinder}

  def index(conn, %{"id" => id}) do
    advice_request = AdvisoryFinder.find(id)
    questionnaire = QuestionnaireFinder.find(advice_request.questionnaire_id)
    questions = QuestionFinder.find_all(questionnaire.question_ids)
    requester = People.find_by(id: advice_request.requester_id) 
    render conn, "advice-form.html", requester: requester, questions: questions
  end
end
