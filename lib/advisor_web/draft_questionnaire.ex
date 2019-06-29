defmodule AdvisorWeb.DraftQuestionnaire do
  import Ecto.Changeset
  use Ecto.Schema
  alias Advisor.Question
  alias Advisor.Question.PhrasesCatalog
  alias __MODULE__

  schema "draft" do
    field(:mentor, :integer)
    field(:mentee, :integer)
    field(:questions, {:map, :boolean})
    field(:advisors, {:map, :boolean})
    field(:message, :string)
  end

  def from_params(%{"draft" => draft}) do
    draft
    |> changeset()
    |> load_questions()
    |> filter_advisors()
  end

  def for_mentee(draft, %{id: mentee}) do
    %{draft | mentee: mentee}
  end

  defp changeset(params) do
    %DraftQuestionnaire{}
    |> cast(params, [:mentor, :questions, :advisors, :message])
    |> apply_changes()
  end

  defp load_questions(%DraftQuestionnaire{questions: questions} = struct) do
    %{struct | questions: load(questions)}
  end

  defp filter_advisors(%DraftQuestionnaire{advisors: advisors} = struct) do
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
