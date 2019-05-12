defmodule Advisor.Core.Notifications do
  import FeatureToggle, only: [enabled: 2]
  alias Advisor.Core.Notifications.Email.Mailer
  alias Advisor.Core.Notifications.Emails

  use Bamboo.Phoenix, view: AdvisorWeb.EmailView

  def about_new_questionnaire(questionnaire) do
    data = %{
      requester: questionnaire.requester,
      mentor: questionnaire.mentor,
      nr_of_questions: length(questionnaire.question_ids),
      message: questionnaire.message
    }

    questionnaire.advice
    |> Enum.filter(fn advice -> enabled(:emails, advice.advisor) end)
    |> Enum.each(fn advice -> advice |> Emails.request_advice(data) |> Mailer.deliver_later() end)
  end

  def questionnaire_completed(questionnaire) do
    data = %{
      requester: questionnaire.requester,
      mentor: questionnaire.mentor,
      questionnaire: questionnaire
    }

    data
    |> Emails.completed()
    |> Mailer.deliver_later()
  end
end
