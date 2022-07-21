defmodule Advisor.Notifications.Emails do
  use Phoenix.Swoosh, view: AdvisorWeb.EmailView

  @source_email Application.get_env(:advisor, Advisor.Notifications.Emails) |> Keyword.fetch!(:source_email)

  def request_advice(advice, data) do
    base()
    |> subject("#{data.mentee.name} would like to get some advice from you!")
    |> to(advice.advisor)
    |> render_body("request-advice.html", advice: advice, data: data)
  end

  def completed(data) do
    base()
    |> subject("The Feedback for #{data.mentee.name} is ready.")
    |> to(data.mentor)
    |> render_body("completed.html", data: data)
  end

  defp base() do
    new()
    |> from(@source_email)
  end
end
