defmodule Advisor.Core.NotificationsTest do
  use AdvisorWeb.ConnCase
  use Bamboo.Test
  alias Advisor.Core.Notifications
  alias Advisor.Test.Support.Sample

  test "sends emails to all advisors" do
    questionnaire = Sample.questionnaire()
    Notifications.about_new_questionnaire(questionnaire)

    subject = "Chris Jordan would like to get some advice from you!"
    assert_email_delivered_with(to: [{"Rabea Gleissner", "rabea@example.com"}], subject: subject)
    assert_email_delivered_with(to: [{"Priya Patil", "priya@example.com"}], subject: subject)
  end

  test "sends an email to the group lead", %{conn: conn} do
    questionnaire = Sample.questionnaire()
    questions = questionnaire.question_ids
    group_lead = questionnaire.group_lead

    Enum.each(questionnaire.advice, fn a -> answer(conn, a, questions) end)

    assert_email_delivered_with(to: [{group_lead.name, group_lead.email}])
  end

  def answer(conn, advice, questions) do
    payload =
      questions
      |> Enum.into(%{}, fn id -> {id, "some answer"} end)
      |> Map.put_new("id", advice.id)

    conn
    |> Login.as(advice.advisor.name)
    |> post(path_for(advice), payload)
    |> html_response(200)
  end

  def path_for(advice) do
    Routes.provide_advice_path(@endpoint, :create, advice.id)
  end
end
