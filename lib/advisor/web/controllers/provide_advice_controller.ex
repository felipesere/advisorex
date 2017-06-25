defmodule Advisor.Web.ProvideAdviceController do
  use Advisor.Web, :controller
  alias Advisor.Core.{AdviceFinder, People, Questionnaire,
                      Questions, Answers}

  import Advisor.Web.Authentication.User, only: [found_in: 1]

  plug  Advisor.Web.Authentication.Gatekeeper

  def index(conn, %{"id" => id}) do
    advice = AdviceFinder.find(id, from_advisor: found_in(conn))

    if advice do
      questionnaire = Questionnaire.find(advice.questionnaire_id)
      questions = Questions.find(questionnaire.question_ids)
      requester = People.find_by(id: advice.requester_id)
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
