defmodule AdvisorWeb.DashboardPageView do
  use AdvisorWeb, :view
  alias Advisor.Core.Dashboard.GroupLeadSection

  def has_advice(%{group_lead_section: %GroupLeadSection{groups: groups}}), do: Enum.any?(groups)

  def needs_to_give_advice(%{required_advice_section: advice}) do
    Enum.any?(advice)
  end

  def awaiting_advice(%{personal_advice_section: personal}), do: personal != :nothing

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
