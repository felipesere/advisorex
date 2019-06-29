defmodule Advisor.Notifications.Emails do
  import Bamboo.Email
  use Bamboo.Phoenix, view: AdvisorWeb.EmailView

  @source_email Application.get_env(:advisor, Advisor.Notifications.Emails) |> Keyword.fetch!(:source_email)

  def request_advice(advice, data) do
    base()
    |> subject("#{data.mentee.name} would like to get some advice from you!")
    |> to(advice.advisor)
    |> render("request-advice.html", advice: advice, data: data)
  end

  def completed(data) do
    base()
    |> subject("The Feedback for #{data.mentee.name} is ready.")
    |> to(data.mentor)
    |> render("completed.html", data: data)
  end

  defp base() do
    new_email()
    |> from(@source_email)
    |> put_layout({AdvisorWeb.EmailView, "base"})
  end
end
