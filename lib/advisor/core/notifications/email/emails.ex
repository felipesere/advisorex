defmodule Advisor.Core.Notifications.Emails do
  import Bamboo.Email
  use Bamboo.Phoenix, view: AdvisorWeb.EmailView

  def request_advice(advice, data) do
    new_email()
    |> from("advisor@8thlight.com")
    |> to(advice.advisor)
    |> render("request-advice.html", advice: advice, data: data)
  end
end
