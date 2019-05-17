defmodule AdvisorWeb.ProvideAdviceController do
  use AdvisorWeb, :controller
  alias Advisor.Core.{Questionnaire, Answer, Advice}
  alias AdvisorWeb.Authentication.User
  alias Advisor.Core.Notifications

  plug AdvisorWeb.Authentication.Gatekeeper

  # TODO: This wants to be pushed down a layer!
  def index(conn, %{"id" => id}) do
    advice = Advice.find(id, from_advisor: User.found_in(conn))

    if advice do
      questionnaire = Questionnaire.find(advice.questionnaire_id)

      render(conn, "advice-form.html",
        mentee: questionnaire.mentee,
        questions: questionnaire.questions,
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

    if Advice.completed?(advice, questionnaire.questions) do
      redirect(conn, to: "/")
    else
      Answer.store(params)

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
