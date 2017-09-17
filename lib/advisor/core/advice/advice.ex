defmodule Advisor.Core.Advice do
  use Ecto.Schema
  import Ecto.Query
  alias Advisor.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "advice_requests" do
    field :questionnaire_id,  :binary_id
    field :requester_id,      :integer
    field :advisor_id,        :integer
    has_many :answers,        Advisor.Core.Answer,
      foreign_key: :advice_request_id,
      on_delete: :delete_all
  end

  defp advice() do
    Advice
    |> select([ar], ar)
    |> preload(:answers)
  end

  def find_all(%{id: id}), do: find_all(id)
  def find_all(id) do
    Repo.all(advice() |> where([advice], advice.questionnaire_id == ^id))
  end

  def find(advisories) when is_list(advisories) do
    ids = ids(advisories)
    Repo.all(advice() |> where([a], a.id in ^ids))
  end
  def find(id) do
    Repo.one(advice() |> where([advice], advice.id == ^id))
  end

  def find(advice_id, [from_advisor: %{id: advisor_id}]) do
    Repo.one(advice() |> where([a], a.id == ^advice_id and a.advisor_id == ^advisor_id))
  end

  def from_advisor(advisor, [for: requester]) do
    Repo.one(advice() |> where([a], a.advisor_id == ^advisor and a.requester_id == ^requester.id))
  end

  def ids(advisories) do
    Enum.map(advisories, &(&1.id))
  end

  def completed?(%Advice{answers: answers}, expected) when is_list(expected) do
    length(answers) == length(expected)
  end
  def completed?(%Advice{answers: answers}, number_of_answers) do
    length(answers) == number_of_answers
  end
end
