defmodule AdvisorWeb.DashboardPageView do
  use AdvisorWeb, :view
  alias Advisor.Dashboard.MentorSection

  def has_advice(%{mentor_section: %MentorSection{groups: groups}}), do: Enum.any?(groups)

  def needs_to_give_advice(%{required_advice_section: advice}) do
    Enum.any?(advice)
  end

  def awaiting_advice(%{personal_advice_section: personal}), do: personal != :nothing

  def path_to_questionnaire(id) do
    Routes.questionnaire_path(AdvisorWeb.Endpoint, :delete, id)
  end

  def path_to_present(id) do
    Routes.present_page_path(AdvisorWeb.Endpoint, :index, id)
  end

  def download_summary(id) do
    Routes.download_summary_path(AdvisorWeb.Endpoint, :export, id)
  end

  def completed?(%{completed: true}), do: "completed"
  def completed?(%{completed: false}), do: "incomplete"
end
