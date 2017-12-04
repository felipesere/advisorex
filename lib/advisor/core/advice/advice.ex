defmodule Advisor.Core.Advice do
  use Ecto.Schema
  import Ecto.Query
  alias Advisor.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "advice_requests" do
    field :questionnaire_id,  :binary_id
    field :requester_id,      :integer
    belongs_to :advisor, Advisor.Core.Person,
      foreign_key: :advisor_id
    has_many :answers,        Advisor.Core.Answer,
      foreign_key: :advice_request_id,
      on_delete: :delete_all
  end

  defp advice() do
    Advice
    |> select([ar], ar)
    |> preload([:answers, :advisor])
  end

  def find_all(%{id: id}), do: find_all(id)
  def find_all(id) do
    Repo.all(advice() |> where([advice], advice.questionnaire_id == ^id))
  end

  def find(advisories) do
    ids = ids(advisories)
    Repo.all(advice() |> where([a], a.id in ^ids))
  end

  def find(advice_id, [from_advisor: %{id: advisor_id}]) do
    Repo.one(advice() |> where([a], a.id == ^advice_id and a.advisor_id == ^advisor_id))
  end

  def from_advisor(advisor) do
    Repo.all(advice() |> where([a], a.advisor_id == ^advisor))
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

  def create(%{questionnaire: %{id: id}}, requester, advisors) do
    advice_requests = Enum.map(advisors, fn(advisor) ->
      %{questionnaire_id: id,
        requester_id: requester,
        advisor_id: advisor}
    end)

    case Repo.insert_all(Advice, advice_requests, returning: true) do
      {_, advisories} -> {:ok, advisories}
      error -> error
    end

  end
end
