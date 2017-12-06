defmodule Advisor.Core.NotificationsTest do
  use Advisor.DataCase
  use Bamboo.Test
  alias Advisor.Core.Notifications
  alias Advisor.Test.Support.Sample

  test "something" do
    questionnaire = Sample.questionnaire
    Notifications.about_new_questionnaire(questionnaire)

    assert_delivered_with(to: [{"Rabea Gleissner", "rabea@example.com"}])
    assert_delivered_with(to: [{"Priya Patil", "priya@example.com"}])
  end
end
