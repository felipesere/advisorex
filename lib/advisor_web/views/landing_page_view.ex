defmodule AdvisorWeb.LandingPageView do
  use AdvisorWeb, :view

  def login_form_for(false) do
    render "_not_logged_in.html"
  end
  def login_form_for(true) do
    render "_logged_in.html"
  end

  def auth_url() do
    "/auth/google"
  end
end
