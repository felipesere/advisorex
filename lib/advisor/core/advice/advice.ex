defmodule Advisor.Core.Advice do
  use Ecto.Schema
  import Ecto.Query
  alias Advisor.Core.Answers
  alias Advisor.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "advice_requests" do
    field :questionnaire_id,  :binary_id
    field :requester_id,      :integer
    field :advisor_id,        :integer
  end

  def find_all(%{id: id}), do: find_all(id)
  def find_all(id) do
    Repo.all(from advice in Advice, where: advice.questionnaire_id == ^id)
  end

  def find(ids) when is_list(ids) do
    ids
    |> Enum.map(&find/1)
    |> Enum.filter(fn(value) -> value end)
  end
  def find(%{id: id}), do: find(id)
  def find(id), do: Repo.get(Advice, id)

  def find(advice_id, [from_advisor: %{id: advisor_id}]) do
    Repo.one(from a in Advice, where: a.id == ^advice_id and a.advisor_id == ^advisor_id)
  end

  def from_advisor(advisor, [for: requester]) do
    Repo.one(from a in Advice, where: a.advisor_id == ^advisor and a.requester_id == ^requester.id)
  end

  def delete_all(advisories) do
    ids = ids(advisories)
    Repo.delete_all(from a in Advice, where: a.id in ^ids)
  end

  def ids(advisories) do
    Enum.map(advisories, &(&1.id))
  end

  def completed?(advice, number_of_answers) do
    length(Answers.find(advice)) == number_of_answers
  end
end
