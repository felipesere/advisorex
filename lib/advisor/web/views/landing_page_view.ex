defmodule Advisor.Web.LandingPageView do
  use Advisor.Web, :view

  def redirecting(false),  do: false
  def redirecting(_),  do: true

  def login_form_for(_, target) when is_binary(target) do
    render "_redirect.html", redirect_to: target
  end
  def login_form_for(false, _) do
    render "_not_logged_in.html"
  end

  def login_form_for(true, _) do
    render "_logged_in.html"
  end
end
