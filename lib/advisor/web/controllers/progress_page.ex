defmodule Advisor.Web.ProgressPage do
  use Advisor.Web, :controller
  alias Advisor.Core.{People, AdviceFinder, Answers, Questionnaire}

  plug  Advisor.Web.Authentication.Gatekeeper, only: :group_leads

  def index(conn, %{"id" => id}) do
    advisories = AdviceFinder.all_for(id)
    questionnaire = Questionnaire.find(id)
    requester = People.requester(questionnaire)

    who_is_done = advisories
                    |> Answers.gather
                    |> Enum.group_by(&(completed?(&1.answers, questionnaire)),
                                     &(People.find_by(&1.advisory)))

    completed = Map.get(who_is_done, true, [])
    incomplete = Map.get(who_is_done, false, [])

    render conn, "index.html", requester: requester,
                               completed: completed,
                               incomplete: incomplete,
                               all_complete:  incomplete == [],
                               questionnaire: questionnaire
  end

  defp completed?(answers, questionnaire) do
    length(answers) == length(questionnaire.question_ids)
  end
end
