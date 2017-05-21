defmodule Advisor.Web.AdviceRequestController do
  use Advisor.Web, :controller
  alias Advisor.Web.{Links, QuestionnaireProposal, Authentication.User}
  alias Advisor.Core.Creator
  import User, only: [found_in: 1]

  plug  Advisor.Web.Authentication.Gatekeeper

  def create(conn, params) do
    {links, progress_link} = params
                             |> QuestionnaireProposal.for_requester(found_in(conn))
                             |> Creator.create
                             |> Links.generate

    render conn, "links.html", links: links, progress_link: progress_link
  end
end
