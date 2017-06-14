defmodule Advisor.Web.QuestionnaireProposal do
  defstruct group_lead: :unassigned,
            requester: :unassigned,
            advisors: [],
            questions: []

  def for_requester(%{"proposal" => %{"group_lead" => lead,
                                      "advisors" => people,
                                      "questions" => questions}}, %{id: id}) do
    with {:ok, lead} <- parse(lead),
         {:ok, people} <- parse(people),
         {:ok, questions} <- parse(questions),
      do: %Advisor.Web.QuestionnaireProposal{group_lead: lead,
                                             advisors: people,
                                             questions: questions,
                                             requester: id}
  end

  def parse(map) when is_map(map) do
    map = Enum.filter_map(map, &truthy/1, fn({key, _}) -> parse!(key) end)

    {:ok, map}
  end
  def parse(potential) when is_binary(potential) do
    case Integer.parse(potential) do
      {number, ""} -> {:ok, number}
      _ -> :could_not_parse_to_integer
    end
  end

  def truthy({_key, "true"}), do: true
  def truthy(_pair), do: false

  def parse!(potential) do
    case Integer.parse(potential) do
      {number, ""} -> number
      _ -> raise "Could not parse to integer"
    end
  end
end
