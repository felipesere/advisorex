defmodule Advisor.Core.Notifications.Emails do
  import Bamboo.Email
  use Bamboo.Phoenix, view: AdvisorWeb.EmailView

  def request_advice(advice, data) do
    base()
    |> subject("#{data.requester.name} would like to get some advice from you!")
    |> to(advice.advisor)
    |> render("request-advice.html", advice: advice, data: data)
  end

  def completed(data) do
    base()
    |> subject("The Feedback for #{data.requester.name} is ready.")
    |> to(data.mentor)
    |> render("completed.html", data: data)
  end

  def base() do
    new_email()
    |> from("advisor@8thlight.com")
    |> put_layout({AdvisorWeb.EmailView, "base"})
  end
end
