defmodule AdvisorWeb.QuestionnaireController do
  use AdvisorWeb, :controller
  alias Advisor.Core.Questionnaire

  plug AdvisorWeb.Authentication.Gatekeeper, only: :group_leads

  def delete(conn, %{"id" => id}) do
    Questionnaire.delete(id)
    redirect(conn, to: "/dashboard")
  end
end
