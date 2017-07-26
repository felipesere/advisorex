defmodule Advisor.Web.ProgressPage do
  use Advisor.Web, :controller
  alias Advisor.Core.{People, Questionnaire, Advice}

  plug  Advisor.Web.Authentication.Gatekeeper, only: :group_leads

  def index(conn, %{"id" => id}) do
    advisories = Advice.all_for(id)
    questionnaire = Questionnaire.find(id)
    requester = People.requester(questionnaire)

    number_of_answers = length(questionnaire.question_ids)
    who_is_done = advisories
                  |> Enum.group_by(&(Advice.completed?(&1, number_of_answers)),
                                                       &People.advisor/1)

    completed = Map.get(who_is_done, true, [])
    incomplete = Map.get(who_is_done, false, [])

    render conn, "index.html", requester: requester,
                               completed: completed,
                               incomplete: incomplete,
                               all_complete:  incomplete == [],
                               questionnaire: questionnaire
  end
end
