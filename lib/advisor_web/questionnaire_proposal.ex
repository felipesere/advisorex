  # TODO: this needs to GO ASAP.

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

    requester = People.find_by(name: requester_name).id
    group_lead = People.group_lead(name: lead_name).id
    advisors = People.find_by(names: advisors_names) |> Enum.map(&(&1.id))

    %QuestionnaireProposal{group_lead: group_lead,
                         requester: requester,
                         advisors: advisors,
                         questions: phrases}
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
