defmodule Advisor.Web.DashboardPageView do
  use Advisor.Web, :view

  def path_to_questionnaire(id) do
    questionnaire_path(Advisor.Web.Endpoint, :delete, id)
  end

  def path_to_present(id) do
    present_page_path(Advisor.Web.Endpoint, :index, id)
  end

  def download_summary(id) do
    download_summary_path(Advisor.Web.Endpoint, :export, id)
  end

  def completed?(%{completed: true}), do: "completed"
  def completed?(%{completed: false}), do: "incomplete"
end
