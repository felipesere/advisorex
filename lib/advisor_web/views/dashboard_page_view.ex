defmodule AdvisorWeb.DashboardPageView do
  use AdvisorWeb, :view

  def path_to_questionnaire(id) do
    questionnaire_path(AdvisorWeb.Endpoint, :delete, id)
  end

  def path_to_present(id) do
    present_page_path(AdvisorWeb.Endpoint, :index, id)
  end

  def download_summary(id) do
    download_summary_path(AdvisorWeb.Endpoint, :export, id)
  end

  def completed?(%{completed: true}), do: "completed"
  def completed?(%{completed: false}), do: "incomplete"
end
