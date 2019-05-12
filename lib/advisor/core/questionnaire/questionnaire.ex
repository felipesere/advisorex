defmodule Advisor.Core.Questionnaire do
  use Ecto.Schema
  import Ecto.Query
  alias __MODULE__
  alias Advisor.Repo
  alias Advisor.Core.Advice

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "questionnaires" do
    field(:question_ids, {:array, :binary})

    belongs_to(:mentee, Advisor.Core.Person, foreign_key: :mentee_id)

    belongs_to(:mentor, Advisor.Core.Person, foreign_key: :mentor_id)

    field(:message, :string)

    has_many(:advice, Advisor.Core.Advice,
      foreign_key: :questionnaire_id,
      on_delete: :delete_all
    )
  end

  defp questionnaire() do
    Questionnaire
    |> select([q], q)
    |> preload([:advice, [advice: [:answers, :advisor]], :mentee, :mentor])
  end

  def all_for_mentor(mentor_id) do
    Repo.all(questionnaire() |> where([q], q.mentor_id == ^mentor_id))
  end

  def questions(%__MODULE__{id: id}), do: questions(id)

  def questions(id) do
    Repo.one(from(q in Questionnaire, where: q.id == ^id, select: q.question_ids))
  end

  def with_mentee(person) do
    Repo.one(questionnaire() |> where([q], q.mentee_id == ^person))
  end

  def find(%Questionnaire{id: id}), do: find(id)
  def find(%{questionnaire_id: id}), do: find(id)

  def find(id) do
    Repo.one(questionnaire() |> where([q], q.id == ^id))
  end

  def delete(id) do
    Repo.delete_all(from(q in Questionnaire, where: q.id == ^id))
  end

  def create(%{question_ids: ids, mentee: r}, %{mentor: gl, message: m}) do
    Repo.insert(%Questionnaire{question_ids: ids, mentor_id: gl, mentee: r, message: m},
      returning: true
    )
  end

  def completed?(%Questionnaire{advice: advice, question_ids: questions}) do
    Enum.all?(advice, fn a -> Advice.completed?(a, questions) end)
  end
end
