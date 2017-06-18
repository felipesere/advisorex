# TODO: We could replace this module with proper usage of url_helper...
defmodule Advisor.Web.Links do
  def generate({:ok, %{advisories: advisories, questionnaire: questionnaire_id}}) do
    links = Enum.map(advisories, fn(advisory) ->
      %{link: "/provide/#{advisory.advice_id}", person: advisory.advisor}
    end)
    progress_link = "/progress/#{questionnaire_id}"
    present_link = "/present/#{questionnaire_id}"
    {links, progress_link, present_link}
  end
end
