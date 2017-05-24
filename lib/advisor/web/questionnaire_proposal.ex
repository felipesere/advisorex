defmodule Advisor.Web.QuestionnaireProposal do
  defstruct group_lead: :unassigned,
            requester: :unassigned,
            advisors: [],
            questions: []


  def for_requester(%{"group_lead" => lead, "people" => people, "questions" => questions},
                    %{id: id}) do
    with {:ok, lead} <- parse(lead),
         {:ok, people} <- parse(people),
         {:ok, questions} <- parse(questions),
      do: %Advisor.Web.QuestionnaireProposal{group_lead: lead,
                                             advisors: people,
                                             questions: questions,
                                             requester: id}
  end

  def for_requester(proposal, request_id) do
    %{proposal | requester: request_id}
  end

  def parse(map) when is_map(map) do
    map = map
          |> Map.keys
          |> Enum.map(&parse!/1)

    {:ok, map}
  end
  def parse(potential) when is_binary(potential) do
    case Integer.parse(potential) do
      {number, ""} -> {:ok, number}
      _ -> :could_not_parse_to_integer
    end
  end

  def parse!(potential) do
    case Integer.parse(potential) do
      {number, ""} -> number
      _ -> raise "Could not parse to integer"
    end
  end
end
