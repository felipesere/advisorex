defmodule Advisor.Web.RequestAdviceController do
  use Advisor.Web, :controller
  alias Advisor.Web.{Links, QuestionnaireProposal}
  alias Advisor.Core.Creator

  def create(conn, params) do
    {links, progress_link} = params
             |> QuestionnaireProposal.from
             |> QuestionnaireProposal.for_requester(1)
             |> Creator.create
             |> Links.generate

    render conn, "links.html", links: links, progress_link: progress_link 
  end
end
