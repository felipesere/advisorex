defmodule Advisor.Web.AdviceRequestController do
  use Advisor.Web, :controller
  alias Advisor.Web.{Links, QuestionnaireProposal, Authentication.User}
  alias Advisor.Core.Creator

  plug  Advisor.Web.Authentication.Gatekeeper

  def create(conn, params) do
    requester_id = User.of(conn).id

    {links, progress_link} = params
             |> QuestionnaireProposal.from
             |> QuestionnaireProposal.for_requester(requester_id)
             |> Creator.create
             |> Links.generate

    render conn, "links.html", links: links, progress_link: progress_link
  end
end
