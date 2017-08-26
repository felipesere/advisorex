defmodule Advisor.Core.Questionnaire do
  use Ecto.Schema
  import Ecto.Query
  alias Advisor.Core.Advice
  alias Advisor.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "questionnaires" do
    field :question_ids, {:array, :binary}
    field :requester_id, :integer
    field :group_lead, :integer
  end

  def for_group_lead(group_lead_id) do
    Repo.all(from q in Questionnaire, where: q.group_lead == ^group_lead_id)
  end

  def with_advisor(person) do
    advisories = Repo.all(from a in Advice,
                          where: a.advisor_id == ^person)

   ids = Enum.map(advisories, fn(x) -> x.questionnaire_id end)

    Repo.all(from q in Questionnaire, where: q.id in ^ids)
  end

  def questions(id) do
    Repo.one(from q in Questionnaire, where: q.id == ^id, select: q.question_ids)
  end

  def with_requester(person) do
    Repo.one(from q in Questionnaire, where: q.requester_id == ^person)
  end

  def find(id) do
    Repo.get(Questionnaire, id)
  end

  def delete(id) do
    Repo.delete_all(from q in Questionnaire, where: q.id == ^id)
  end

  defmodule Created do
    defstruct questionnaire: :unassigned, advisories: []
  end
end
