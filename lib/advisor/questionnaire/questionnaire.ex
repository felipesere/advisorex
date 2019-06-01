defmodule Advisor.Questionnaire do
  use Ecto.Schema
  import Ecto.Query
  alias __MODULE__
  alias Advisor.Repo
  alias Advisor.{Advice, Question}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "questionnaires" do
    belongs_to(:mentee, Advisor.Person, foreign_key: :mentee_id)
    belongs_to(:mentor, Advisor.Person, foreign_key: :mentor_id)

    field(:message, :string)

    has_many(:advice, Advisor.Advice,
      foreign_key: :questionnaire_id,
      on_delete: :delete_all
    )

    has_many(:questions, Advisor.Question)
  end

  defp questionnaire() do
    Questionnaire
    |> select([q], q)
    |> preload([:advice, [advice: [:answers, :advisor]], :mentee, :mentor, :questions])
  end

  def all_for_mentor(mentor_id) do
    Repo.all(questionnaire() |> where([q], q.mentor_id == ^mentor_id))
  end

  def questions(id) do
    id
    |> find()
    |> Map.fetch!(:questions)
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

  def create(%{
        mentor: mentor_id,
        mentee: mentee_id,
        message: m,
        questions: phrases,
        advisors: advisors
      }) do
    questions = Enum.map(phrases, fn p -> %Question{phrase: p} end)
    advice = Enum.map(advisors, fn advisor -> %Advice{advisor_id: advisor} end)

    Repo.insert!(%Questionnaire{
      mentor_id: mentor_id,
      mentee_id: mentee_id,
      message: m,
      questions: questions,
      advice: advice
    })
  end

  def completed?(%Questionnaire{advice: advice, questions: questions}) do
    Enum.all?(advice, fn a -> Advice.completed?(a, questions) end)
  end
end
