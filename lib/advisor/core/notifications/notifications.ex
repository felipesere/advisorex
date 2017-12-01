defmodule Advisor.Core.Notifications do
  import Bamboo.Email
  alias Advisor.Core.Notifications.Email.Mailer
  alias Advisor.Core.People
  alias Advisor.Core.Advice
  use Bamboo.Phoenix, view: AdvisorWeb.EmailView

  def about_new_questionnaire(questionnaire) do
    Apex.ap questionnaire
    a = questionnaire
        |> Advice.find_all()
        |> advice_and_person()

   requester = People.requester(questionnaire)

    Enum.each(a, fn(%{advice: advice, person: person}) ->
      basic_mail()
      |> to(person)
      |> render("request-advice.html", advisor: person, advice: advice, requester: requester)
      |> Mailer.deliver_now
    end)
  end

  def advice_and_person(advisories) do
    Apex.ap advisories
    Enum.map(advisories, fn(advice) -> %{advice: advice, person: People.advisor(advice)} end)
  end

  def basic_mail() do
    new_email(
      from: "advisor@8thlight.com",
    )
  end
end
