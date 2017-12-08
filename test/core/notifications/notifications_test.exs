defmodule Advisor.Core.NotificationsTest do
  use Advisor.DataCase
  use Bamboo.Test
  alias Advisor.Core.Notifications
  alias Advisor.Test.Support.Sample

  test "sends emails to all advisors" do
    questionnaire = Sample.questionnaire
    Notifications.about_new_questionnaire(questionnaire)

    subject = "Chris Jordan would like to get some advice from you!"
    assert_delivered_with(to: [{"Rabea Gleissner", "rabea@example.com"}], subject: subject)
    assert_delivered_with(to: [{"Priya Patil", "priya@example.com"}], subject: subject)
  end
end
