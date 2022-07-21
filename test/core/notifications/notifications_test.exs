defmodule Advisor.NotificationsTest do
  use AdvisorWeb.ConnCase
  alias Advisor.Notifications
  alias Advisor.Test.Support.Sample
  import Swoosh.TestAssertions

  test "sends emails to all advisors" do
    Notifications.about_new_questionnaire(Sample.questionnaire())

    subject = "Chris Jordan would like to get some advice from you!"
    assert_email_sent(to: [{"Rabea Gleissner", "rabea@example.com"}], subject: subject)
    assert_email_sent(to: [{"Priya Patil", "priya@example.com"}], subject: subject)
  end

  test "sends an email to the mentor", %{conn: conn} do
    questionnaire = Sample.questionnaire()
    questions = questionnaire.questions
    mentor = questionnaire.mentor

    Enum.each(questionnaire.advice, fn a -> answer(conn, a, questions) end)

    assert_email_sent(to: [{mentor.name, mentor.email}])
  end

  def answer(conn, advice, questions) do
    answered =
      Enum.into(questions, %{"id" => advice.questionnaire_id}, fn q -> {q.id, "some answer"} end)

    conn
    |> Login.as(advice.advisor.name)
    |> Submit.answers!(answered, for: %{id: advice.questionnaire_id})
  end
end
