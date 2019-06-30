defmodule Advisor.Advice do
  use Ecto.Schema
  import Ecto.Query
  alias Advisor.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "advice" do
    field(:questionnaire_id, :binary_id)
    belongs_to(:advisor, Advisor.Person, foreign_key: :advisor_id)

    has_many(:answers, Advisor.Answer,
      foreign_key: :advice_id,
      on_delete: :delete_all
    )
  end

  def from_advisor(advisor) do
    Repo.all(advice() |> where([a], a.advisor_id == ^advisor))
  end

  def save_answers(advice, answers) do
    answers = Advisor.Answer.all_answers_in(answers)

    advice
    |> Ecto.Changeset.change(%{answers: answers})
    |> Repo.update!()
  end

  def completed?(%Advice{answers: answers}, expected) when is_list(expected) do
    length(answers) == length(expected)
  end

  def completed?(%Advice{answers: answers}, number_of_answers) do
    length(answers) == number_of_answers
  end

  defp advice() do
    Advice
    |> select([ar], ar)
    |> preload([:answers, :advisor])
  end

  def by(person, [questionnaire: q]) do
    %Advice{advisor_id: person.id, questionnaire_id: q.id}
    |> Repo.insert!()
  end
end
