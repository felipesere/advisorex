defmodule AdvisorWeb.AdviceRequestView do
  use AdvisorWeb, :view

  def a_link(advice), do: provide_advice_path(@endpoint, :index, advice.id)
  def progress_link(questionnaire), do: progress_page_path(@endpoint, :index, questionnaire.id)
end
