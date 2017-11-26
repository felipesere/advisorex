defmodule AdvisorWeb.LandingPageView do
  use AdvisorWeb, :view
  alias Advisor.Core.People

  # used in dev for the login page
  def everybody() do
    People.everybody()
  end
end
