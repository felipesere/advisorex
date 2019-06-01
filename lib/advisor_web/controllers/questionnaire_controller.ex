defmodule AdvisorWeb.QuestionnaireController do
  use AdvisorWeb, :controller
  alias Advisor.Questionnaire

  plug AdvisorWeb.Authentication.Gatekeeper, only: :mentors

  def delete(conn, %{"id" => id}) do
    Questionnaire.delete(id)
    send_resp(conn, 200, "")
  end
end
