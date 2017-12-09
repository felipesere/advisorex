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
end
