defmodule Advisor.Web.RequestAdviceController do
  use Advisor.Web, :controller

  def create(conn, params) do
    render conn, "links.html", links: [], progress_link: ""
  end
end
