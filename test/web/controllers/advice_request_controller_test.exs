defmodule AdvisorWeb.DraftQuestionnaireControllerTest do
  use AdvisorWeb.ConnCase
  alias Advisor.Test.Support.Users
  alias PageAssertions, as: It

  test "creates the proper questionnaire", %{conn: conn} do
    [felipe, cj, priya] = Users.with(["Felipe Sere", "Chris Jordan", "Priya Patil"])

    conn
    |> Login.as(priya)
    |> Submit.questionnaire(asking: [cj], mentor: felipe, questions: [13])
    |> It.has_title("Here are your links:")
    |> It.has_links_to_advice(1)
    |> It.has_see_advice_link()
  end

  test "redirects unauthenticated users back to the landing page", %{conn: conn} do
    conn = post conn, "/request", []

    assert redirected_to(conn) == "/"
  end
end
