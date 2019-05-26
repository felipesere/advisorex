defmodule AdvisorWeb.TestSupportController do
  use AdvisorWeb, :controller
  alias Advisor.Core.Questionnaire
  alias Advisor.Repo

  def delete_all(conn, _params) do
    Repo.delete_all(Questionnaire)
    send_resp(conn, 200, "")
  end
end
