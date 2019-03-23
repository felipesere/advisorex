defmodule AdvisorWeb.EmailView do

  use AdvisorWeb, :view

  @endpoint AdvisorWeb.Endpoint

  def advice_path(advice),  do: Routes.provide_advice_url(@endpoint, :index, advice.id)
  def landing_page(), do: Routes.landing_page_url(@endpoint, :index)
  def questionnaire(questionnaire), do: Routes.present_page_url(@endpoint, :index, questionnaire.id)

  def color(:green),      do: "#52aa5e"
  def color(:primary),    do: "#27a8e0"
  def color(:text),       do: "#495561"
  def color(:background), do: "#f6f7f8"
  def color(:dark_grey),  do: "#83919f"
  def color(:light_grey), do: "#d9dee2"

  def questions(1), do: "a single question"
  def questions(2), do: "two questions"
  def questions(n), do: "#{n} questions"
end
