defmodule AdvisorWeb.Links do
  def generate({:ok, %{advisories: advisories, questionnaire: questionnaire_id}}) do
    links = Enum.map(advisories, fn(advice) ->
      %{link: "/provide/#{advice.id}", person: advice.advisor}
    end)
    progress_link = "/progress/#{questionnaire_id}"
    present_link = "/present/#{questionnaire_id}"
    {links, progress_link, present_link}
  end
end
