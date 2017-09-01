  # TODO: this needs to GO ASAP.

defmodule AdvisorWeb.QuestionnaireProposal do
  alias Advisor.Core.People
  alias Advisor.Core.Questions
  alias Advisor.Core.Questions.PhrasesCatalog
  alias __MODULE__

  defstruct group_lead: :unassigned,
            requester: :unassigned,
            advisors: [],
            questions: []

  def build([for: requester_name,
             advisors: advisors_names,
             group_lead: lead_name,
             questions: phrases]) do

    questions = Questions.store(phrases)
    requester = People.find_by(name: requester_name).id
    group_lead = People.group_lead(name: lead_name).id
    advisors = People.find_by(names: advisors_names) |> Enum.map(&(&1.id))

    %QuestionnaireProposal{group_lead: group_lead,
                         requester: requester,
                         advisors: advisors,
                         questions: questions}
  end

  def for_requester(%{"proposal" => %{"group_lead" => lead,
                                      "advisors" => people,
                                      "questions" => questions}}, %{id: id}) do

    questions = questions |> identify() |> load()

    with {:ok, lead} <- parse(lead),
         {:ok, people} <- parse(people),
      do: %AdvisorWeb.QuestionnaireProposal{group_lead: lead,
                                             advisors: people,
                                             questions: questions,
                                             requester: id}
  end

  def identify(phrase_or_id) do
    keys = Map.keys(phrase_or_id)
    if all_integers(keys) do
      {:ids, parse(phrase_or_id)}
    else
      {:phrases, parse(phrase_or_id)}
    end
  end

  def load({:ids, {:ok, ids}}) do
    ids
    |> PhrasesCatalog.find
    |> Questions.phrases
  end

  def all_integers(phrase_or_id) do
    Enum.all?(phrase_or_id, fn(element) ->
      case Integer.parse(element) do
        {_, ""} -> true
        _ -> false
      end
    end)
  end

  def parse(map) when is_map(map) do
    map = map
          |> Enum.filter(&truthy/1)
          |> Enum.map(fn({key, _}) -> parse!(key) end)

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
