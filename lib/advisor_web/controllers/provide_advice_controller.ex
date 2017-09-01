defmodule AdvisorWeb.ProvideAdviceController do
  use AdvisorWeb, :controller
  alias Advisor.Core.{People, Questions, Questionnaire, Answers, Advice}

  import AdvisorWeb.Authentication.User, only: [found_in: 1]

  plug  AdvisorWeb.Authentication.Gatekeeper

  # TODO: This is long and by the way... did you notice the sneaky if/else?
  def index(conn, %{"id" => id}) do
    advice = Advice.find(id, from_advisor: found_in(conn))

    if advice do
      questions = advice.questionnaire_id
                  |> Questionnaire.questions()
                  |> Questions.load()
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
