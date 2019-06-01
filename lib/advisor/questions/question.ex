defmodule Advisor.Question do
  use Ecto.Schema

  @type t :: %__MODULE__{id: String.t(), phrase: String.t()}
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "questions" do
    field(:phrase, :string)
    belongs_to(:questionnaire, Advisor.Questionnaire, type: :binary_id)
  end

  def phrases(questions), do: Enum.map(questions, fn question -> question.phrase end)
end
