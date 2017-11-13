defmodule AdvisorWeb.QuestionnaireProposal do
  import Ecto.Changeset
  use Ecto.Schema
  alias Advisor.Core.Questions
  alias Advisor.Core.Questions.PhrasesCatalog
  alias __MODULE__

  schema "proposal" do
    field :group_lead, :integer
    field :requester, :integer
    field :questions, {:map, :boolean}
    field :advisors, {:map, :boolean}
    field :message, :string
  end

  def from_params(%{"proposal" => proposal}) do
    proposal
    |> changeset()
    |> load_questions()
    |> filter_advisors()
  end

  def for_requester(proposal, %{id: requester}) do
    %{proposal | requester: requester}
  end

  def changeset(params) do
    %QuestionnaireProposal{}
    |> cast(params, [:group_lead, :questions, :advisors, :message])
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
