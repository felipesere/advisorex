defmodule Advisor.Web.LandingPageView do
  use Advisor.Web, :view

  def csrf_token() do
    Phoenix.Controller.get_csrf_token()
  end
end
