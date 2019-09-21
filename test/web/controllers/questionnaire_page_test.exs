defmodule AdvisorWeb.RequestPageTest do
  use AdvisorWeb.ConnCase
  alias Advisor.Test.Support.Users
  alias Advisor.People
  alias Advisor.Question.PhrasesCatalog
  alias PageAssertions, as: It

  @myself 1

  test "cannot request advice if not authenticated", %{conn: conn} do
    conn = get(conn, "/request")

    assert redirected_to(conn) == "/"
  end

  test "sees the page to create a questionnaire", %{conn: conn} do
    Users.with(:everybody)

    number_of_mentors = length(People.mentors()) - @myself
    number_of_advisors = length(People.everybody()) - @myself
    number_of_questions = PhrasesCatalog.all() |> flatten |> length

    conn
    |> Login.as("Felipe Sere")
    |> Visit.the(:create_questionnaire)
    |> It.has_title("Hello Felipe Sere!")
    |> has_mentors(number_of_mentors)
    |> has_advisors(number_of_advisors)
    |> has_questions(number_of_questions)
  end

  defp flatten(%{client: c, technical: t, community: co}), do: c ++ t ++ co

  defp has_mentors(html, number) do
    assert html
           |> Floki.find("[data-testid=mentor]")
           |> length == number

    html
  end

  defp has_advisors(html, number) do
    assert html
           |> Floki.find("[data-testid=advisor]")
           |> length == number

    html
  end

  def has_questions(html, number) do
    assert html
           |> Floki.find(".question-picker li")
           |> length == number

    html
  end
end
