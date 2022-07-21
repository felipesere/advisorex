defmodule Advisor.Notifications do
  import FeatureToggle, only: [enabled: 2]
  alias Advisor.Notifications.Email.Mailer
  alias Advisor.Notifications.Emails

  use Phoenix.Swoosh, view: AdvisorWeb.EmailView

  def about_new_questionnaire(questionnaire) do
    data = %{
      mentee: questionnaire.mentee,
      mentor: questionnaire.mentor,
      nr_of_questions: length(questionnaire.questions),
      message: questionnaire.message
    }

    questionnaire.advice
    |> Enum.filter(fn advice -> enabled(:emails, advice.advisor) end)
    |> Enum.each(fn advice -> advice |> Emails.request_advice(data) |> Mailer.deliver() end)
  end

  def questionnaire_completed(questionnaire) do
    data = %{
      mentee: questionnaire.mentee,
      mentor: questionnaire.mentor,
      questionnaire: questionnaire
    }

    data
    |> Emails.completed()
    |> Mailer.deliver()
  end
end
