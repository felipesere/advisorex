defmodule AdvisorWeb.QuestionnaireProposal do
  import Ecto.Changeset
  use Ecto.Schema
  alias Advisor.Question
  alias Advisor.Question.PhrasesCatalog
  alias __MODULE__

  schema "proposal" do
    field(:mentor, :integer)
    field(:mentee, :integer)
    field(:questions, {:map, :boolean})
    field(:advisors, {:map, :boolean})
    field(:message, :string)
  end

  def from_params(%{"proposal" => proposal}) do
    proposal
    |> changeset()
    |> load_questions()
    |> filter_advisors()
  end

  def for_mentee(proposal, %{id: mentee}) do
    %{proposal | mentee: mentee}
  end

  defp changeset(params) do
    %QuestionnaireProposal{}
    |> cast(params, [:mentor, :questions, :advisors, :message])
    |> apply_changes()
  end

  defp load_questions(%QuestionnaireProposal{questions: questions} = struct) do
    %{struct | questions: load(questions)}
  end

  defp filter_advisors(%QuestionnaireProposal{advisors: advisors} = struct) do
    %{struct | advisors: ids(advisors)}
  end

  defp load(questions) do
    questions
    |> ids()
    |> PhrasesCatalog.find()
    |> Question.phrases()
  end

  defp ids(map) do
    map
    |> Enum.filter(fn {_, v} -> v end)
    |> Enum.map(fn {k, _} -> parse!(k) end)
  end

  defp parse!(potential) do
    case Integer.parse(potential) do
      {number, ""} -> number
      _ -> raise "Could not parse to integer"
    end
  end
end
