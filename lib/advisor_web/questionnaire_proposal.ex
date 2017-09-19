  # FIXME: Maybe not...? Using it to do schema validation might bring life back to it

defmodule AdvisorWeb.QuestionnaireProposal do
  import Ecto.Changeset
  use Ecto.Schema
  alias Advisor.Core.People
  alias Advisor.Core.Questions
  alias Advisor.Core.Questions.PhrasesCatalog
  alias __MODULE__

  schema "proposal" do
    field :group_lead, :integer
    field :requester, :integer
    field :questions, {:map, :boolean}
    field :advisors, {:map, :boolean}
  end

  def build([for: requester_name,
             advisors: advisors_names,
             group_lead: lead_name,
             questions: phrases]) do

    requester = People.find_by(name: requester_name)
    group_lead = People.group_lead(name: lead_name)
    advisors = People.find_by(names: advisors_names)
                          |> Enum.map(&(&1.id))
                          |> Enum.map(fn(a) -> {Integer.to_string(a), "true"} end)
                          |> Enum.into(%{})
    questions = phrases
                |> Enum.map(fn(a) -> {Integer.to_string(a), "true"} end)
                |> Enum.into(%{})

    proposal_form = %{"proposal" => %{
      "group_lead" => Integer.to_string(group_lead.id),
      "questions" => questions,
      "advisors" => advisors
    }}
    for_requester(proposal_form, %{id: requester.id})
  end

  def for_requester(%{"proposal" => proposal}, %{id: requester}) do
    proposal
    |> changeset(requester)
    |> load_questions()
    |> filter_advisors()
  end

  def changeset(params, id) do
    %QuestionnaireProposal{}
    |> cast(params, [:group_lead, :questions, :advisors])
    |> put_change(:requester, id)
    |> apply_changes()
  end

  def load_questions(%QuestionnaireProposal{questions: questions} = struct) do
    %{struct | questions: load(questions)}
  end

  def filter_advisors(%QuestionnaireProposal{advisors: advisors} = struct) do
    %{struct | advisors: ids(advisors)}
  end

  def load(questions) do
    questions
    |> ids()
    |> PhrasesCatalog.find()
    |> Questions.phrases()
  end

  def ids(map) do
    map
    |> Enum.filter(fn({_, v}) -> v end)
    |> Enum.map(fn({k, _}) -> parse!(k) end)
  end

  def parse!(potential) do
    case Integer.parse(potential) do
      {number, ""} -> number
      _ -> raise "Could not parse to integer"
    end
  end
end
