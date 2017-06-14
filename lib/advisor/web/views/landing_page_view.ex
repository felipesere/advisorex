defmodule Advisor.Web.LandingPageView do
  alias Phoenix.Controller
  use Advisor.Web, :view

  def csrf_token() do
    Controller.get_csrf_token()
  end
end
