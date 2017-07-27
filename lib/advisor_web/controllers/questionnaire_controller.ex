defmodule AdvisorWeb.QuestionnaireController do
  use AdvisorWeb, :controller
  alias Advisor.Core.Questionnaire.Deleter

  plug AdvisorWeb.Authentication.Gatekeeper, only: :group_leads

  def delete(conn, %{"id" => id}) do
    Deleter.delete(id)
    redirect(conn, to: "/dashboard")
  end
end
