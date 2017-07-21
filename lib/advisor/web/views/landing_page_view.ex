defmodule Advisor.Web.LandingPageView do
  use Advisor.Web, :view

  def redirecting(false),  do: false
  def redirecting(_),  do: true
end
