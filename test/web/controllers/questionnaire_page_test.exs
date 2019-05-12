defmodule AdvisorWeb.RequestPageTest do
  use AdvisorWeb.ConnCase
  alias Advisor.Test.Support.Users
  alias Advisor.Core.People
  alias Advisor.Core.Questions.PhrasesCatalog

  @myself 1

  test "cannot request advice if not authenticated", %{conn: conn} do
    conn = get(conn, "/request")

    assert redirected_to(conn) == "/"
  end

  # TODO: pretty sure this test never fails?
  test "sees the page to create a questionnaire", %{conn: conn} do
    Users.with("Felipe Sere")

    conn =
      conn
      |> Login.as("Felipe Sere")
      |> get("/request")

    response = html_response(conn, 200)

    assert response
           |> Floki.find("h1")
           |> Enum.at(0)
           |> Floki.text() == "Hello Felipe Sere!"

    number_of_mentor = length(People.mentors()) - @myself

    assert response
           |> Floki.find(".mentor")
           |> length == number_of_mentor

    number_of_advisors = length(People.everybody()) - @myself

    assert response
           |> Floki.find(".advisor")
           |> length == number_of_advisors

    number_of_questions = PhrasesCatalog.all() |> flatten |> length

    assert response
           |> Floki.find(".question-picker li")
           |> length == number_of_questions
  end

  defp flatten(%{client: c, technical: t, community: co}), do: c ++ t ++ co
end
