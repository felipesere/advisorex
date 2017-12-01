defmodule Advisor.Core.NotificationsTest do
  use Advisor.DataCase
  use Bamboo.Test
  alias Advisor.Core.Notifications
  alias Advisor.Test.Support.Sample

  test "something" do
    questionnaire = Sample.questionnaire
    Notifications.about_new_questionnaire(questionnaire)

    #assert_delivered_email Bamboo.Email.new_email(to: "fsere@8thlight.com",
    #                                             from: "advisor@8thlight.com")
  end
end
