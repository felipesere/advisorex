defmodule AdvisorWeb.ProgressPage do
  use AdvisorWeb, :controller
  alias Advisor.Core.{Questionnaire, Advice}

  plug AdvisorWeb.Authentication.Gatekeeper, only: :mentors

  def index(conn, %{"id" => id}) do
    questionnaire = Questionnaire.find(id)

    who_is_done = group_by_completion(questionnaire)

    completed = Map.get(who_is_done, true, [])
    incomplete = Map.get(who_is_done, false, [])

    render(conn, "index.html",
      requester: questionnaire.requester,
      completed: completed,
      incomplete: incomplete,
      all_complete: incomplete == [],
      questionnaire: questionnaire
    )
  end

  defp group_by_completion(%Questionnaire{advice: advice, question_ids: question_ids}) do
    advice
    |> Enum.group_by(&Advice.completed?(&1, question_ids), & &1.advisor)
  end
end
