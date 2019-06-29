defmodule AdvisorWeb.DraftQuestionnaireView do
  use AdvisorWeb, :view

  def provide_advice(%{questionnaire_id: id}),
    do: Routes.provide_advice_path(@endpoint, :index, id)

  def progress_link(questionnaire),
    do: Routes.progress_page_path(@endpoint, :index, questionnaire.id)
end
