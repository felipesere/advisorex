defmodule Advisor.Core.Questionnaire do
  use Ecto.Schema
  import Ecto.Query
  alias Advisor.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "questionnaires" do
    field :question_ids, {:array, :binary}

    belongs_to :requester, Advisor.Core.Person,
      foreign_key: :requester_id

    belongs_to :group_lead, Advisor.Core.Person,
      foreign_key: :group_lead_id

    field :message, :string
    has_many :advice, Advisor.Core.Advice,
      foreign_key: :questionnaire_id,
      on_delete: :delete_all
  end

  defp questionnaire() do
    Questionnaire
    |> select([q], q)
    |> preload([:advice, [advice: [:answers, :advisor]], :requester, :group_lead])
  end

  def all_for_group_lead(group_lead_id) do
    Repo.all(questionnaire() |> where([q], q.group_lead_id == ^group_lead_id))
  end

  def questions(%__MODULE__{id: id}), do: questions(id)
  def questions(id) do
    Repo.one(from q in Questionnaire, where: q.id == ^id, select: q.question_ids)
  end

  def with_requester(person) do
    Repo.one(questionnaire() |> where([q], q.requester_id == ^person))
  end

  def find(%Questionnaire{id: id}), do: find(id)
  def find(%{questionnaire_id: id}), do: find(id)
  def find(id) do
    Repo.one(questionnaire() |> where([q], q.id == ^id))
  end

  def delete(id) do
    Repo.delete_all(from q in Questionnaire, where: q.id == ^id)
  end

  def create(%{question_ids: ids}, requester, group_lead, message) do
    Repo.insert(%Questionnaire{question_ids: ids,
                                group_lead_id: group_lead,
                                requester: requester,
                                message: message}, returning: true)
  end
end
