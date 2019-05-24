defmodule Advisor.Core.Question do
  use Ecto.Schema
  alias Advisor.Repo
  alias __MODULE__

  @type t :: %__MODULE__{id: String.t(), phrase: String.t()}
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "questions" do
    field(:phrase, :string)
    belongs_to(:questionnaire, Advisor.Core.Questionnaire, type: :binary_id)
  end

  def store(phrases) do
    phrases = Enum.map(phrases, &%{phrase: &1})

    {_, questions} = Repo.insert_all(Question, phrases, returning: true)

    Enum.map(questions, & &1.id)
  end

  def phrases(questions), do: Enum.map(questions, fn question -> question.phrase end)
end
