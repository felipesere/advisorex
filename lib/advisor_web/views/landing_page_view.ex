defmodule AdvisorWeb.LandingPageView do
  use AdvisorWeb, :view
  alias Advisor.Core.People

  def login_form_for(false) do
    render "_not_logged_in.html"
  end
  def login_form_for(true) do
    render "_logged_in.html"
  end

  # used in dev for the login page
  def everybody() do
    People.everybody()
  end
end
