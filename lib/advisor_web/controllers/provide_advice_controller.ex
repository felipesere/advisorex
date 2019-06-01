defmodule AdvisorWeb.ProvideAdviceController do
  use AdvisorWeb, :controller
  alias Advisor.{Questionnaire, Advice}
  alias AdvisorWeb.Authentication.User
  alias Advisor.Notifications

  plug AdvisorWeb.Authentication.Gatekeeper

  # TODO: This wants to be pushed down a layer!
  def index(conn, %{"id" => questionnaire_id}) do
    possible_advisor = User.found_in(conn)
    questionnaire = Questionnaire.find(questionnaire_id)
    # TODO: this may crash if there is no real questionnaire id coming in!
    legitimate_advisor =
      Enum.find(questionnaire.advice, fn advice -> advice.advisor == possible_advisor end)

    if questionnaire && legitimate_advisor do
      render(conn, "advice-form.html",
        mentee: questionnaire.mentee,
        questions: questionnaire.questions,
        message: questionnaire.message,
        questionnaire_id: questionnaire.id
      )
    else
      conn
      |> fetch_session()
      |> put_session(:target, conn.request_path)
      |> redirect(to: "/")
    end
  end

  def create(conn, %{"id" => questionnaire_id} = params) do
    advisor = User.found_in(conn)
    questionnaire = Questionnaire.find(questionnaire_id)

    # TODO: this may crash if the advisor is wrong
    advice =
      Advice.from_advisor(advisor.id)
      |> Enum.find(fn a -> a.questionnaire_id == questionnaire_id end)

    if Advice.completed?(advice, questionnaire.questions) do
      redirect(conn, to: "/")
    else
      Advice.save_answers(advice, params)

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
