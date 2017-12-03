defmodule Advisor.Core.Notifications do
  import Bamboo.Email
  alias Advisor.Core.Notifications.Email.Mailer
  use Bamboo.Phoenix, view: AdvisorWeb.EmailView

  def about_new_questionnaire(questionnaire) do
   requester = questionnaire.requester

    Enum.each(questionnaire.advice, fn(advice) ->
      basic_mail()
      |> to(advice.advisor)
      |> render("request-advice.html", advice: advice, requester: requester)
      |> Mailer.deliver_now
    end)
  end

  def basic_mail() do
    new_email(
      from: "advisor@8thlight.com",
    )
  end
end
