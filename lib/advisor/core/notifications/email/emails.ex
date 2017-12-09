defmodule Advisor.Core.Notifications.Emails do
  import Bamboo.Email
  use Bamboo.Phoenix, view: AdvisorWeb.EmailView

  def request_advice(advice, data) do
    new_email()
    |> from("advisor@8thlight.com")
    |> subject("#{data.requester.name} would like to get some advice from you!")
    |> to(advice.advisor)
    |> put_layout({AdvisorWeb.EmailView, "base"})
    |> render("request-advice.html", advice: advice, data: data)
  end

  def completed(data) do
    new_email()
    |> from("advisor@8thlight.com")
    |> subject("The Feedback for #{data.requester.name} is ready.")
    |> to(data.group_lead)
    |> put_layout({AdvisorWeb.EmailView, "base"})
    |> render("completed.html", data: data)
  end
end
