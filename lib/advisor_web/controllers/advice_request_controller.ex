defmodule AdvisorWeb.AdviceRequestController do
  use AdvisorWeb, :controller
  alias AdvisorWeb.{Links, QuestionnaireProposal, Authentication.User}
  alias Advisor.Core.Questionnaire.Creator
  import User, only: [found_in: 1]

  plug  AdvisorWeb.Authentication.Gatekeeper

  def create(conn, params) do
    {links, progress, _} = params
                        |> QuestionnaireProposal.for_requester(found_in(conn))
                        |> Creator.create
                        |> Links.generate

    render conn, "links.html", links: links, progress_link: progress
  end
end
