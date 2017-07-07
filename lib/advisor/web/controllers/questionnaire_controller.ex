defmodule Advisor.Web.QuestionnaireController do
  use Advisor.Web, :controller
  alias Advisor.Core.Questionnaire.Deleter

  plug Advisor.Web.Authentication.Gatekeeper, only: :group_leads

  def delete(conn, %{"id" => id}) do
    Deleter.delete(id)
    redirect(conn, to: "/dashboard")
  end
end
