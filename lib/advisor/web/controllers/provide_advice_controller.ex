defmodule Advisor.Web.ProvideAdviceController do
  use Advisor.Web, :controller
  alias Advisor.Core.{AdvisoryFinder, People, QuestionnaireFinder,
                      QuestionFinder, Answers}

  import Advisor.Web.Authentication.User, only: [found_in: 1]

  plug  Advisor.Web.Authentication.Gatekeeper

  def index(conn, %{"id" => id}) do
    advice_request = AdvisoryFinder.find(id, for_user: found_in(conn))

    if advice_request do
      questionnaire = QuestionnaireFinder.find(advice_request.questionnaire_id)
      questions = QuestionFinder.find_all(questionnaire.question_ids)
      requester = People.find_by(id: advice_request.requester_id)
      render(conn, "advice-form.html", requester: requester,
                                       questions: questions,
                                       advice_id: id)
    else
      conn
      |> put_resp_cookie("target", conn.request_path)
      |> redirect(to: "/")
    end
  end

  def create(conn, params) do
    Answers.store(params)
    render conn, "thank-you.html"
  end
end
