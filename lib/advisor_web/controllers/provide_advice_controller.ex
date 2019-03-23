defmodule AdvisorWeb.ProvideAdviceController do
  use AdvisorWeb, :controller
  alias Advisor.Core.{Questions, Questionnaire, Answers, Advice}
  alias AdvisorWeb.Authentication.User
  alias Advisor.Core.Notifications

  plug AdvisorWeb.Authentication.Gatekeeper

  # TODO: This wants to be pushed down a layer!
  def index(conn, %{"id" => id}) do
    advice = Advice.find(id, from_advisor: User.found_in(conn))

    if advice do
      questionnaire = Questionnaire.find(advice.questionnaire_id)

      questions =
        questionnaire
        |> Questionnaire.questions()
        |> Questions.load()

      render(conn, "advice-form.html",
        requester: questionnaire.requester,
        questions: questions,
        advice_id: id,
        message: questionnaire.message
      )
    else
      conn
      |> fetch_session()
      |> put_session(:target, conn.request_path)
      |> redirect(to: "/")
    end
  end

  def create(conn, %{"id" => id} = params) do
    advice = Advice.find(id, from_advisor: User.found_in(conn))
    questionnaire = Questionnaire.find(advice)

    if Advice.completed?(advice, questionnaire.question_ids) do
      redirect(conn, to: "/")
    else
      Answers.store(params)

      questionnaire
      |> Questionnaire.find()
      |> notify()

      render(conn, "thank-you.html")
    end
  end

  def notify(questionnaire) do
    if Questionnaire.completed?(questionnaire) do
      Notifications.questionnaire_completed(questionnaire)
    end
  end
end
