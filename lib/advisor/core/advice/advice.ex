defmodule Advisor.Core.Advice do
  use Ecto.Schema
  import Ecto.Query
  alias Advisor.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "advice" do
    field(:questionnaire_id, :binary_id)
    belongs_to(:advisor, Advisor.Core.Person, foreign_key: :advisor_id)

    has_many(:answers, Advisor.Core.Answer,
      foreign_key: :advice_request_id,
      on_delete: :delete_all
    )
  end

  defp advice() do
    Advice
    |> select([ar], ar)
    |> preload([:answers, :advisor])
  end

  # Why does this return a list?
  def from_advisor(advisor) do
    Repo.all(advice() |> where([a], a.advisor_id == ^advisor))
  end

  def ids(advisories) do
    Enum.map(advisories, & &1.id)
  end

  def completed?(%Advice{answers: answers}, expected) when is_list(expected) do
    length(answers) == length(expected)
  end

  def completed?(%Advice{answers: answers}, number_of_answers) do
    length(answers) == number_of_answers
  end

  def create(%{questionnaire: %{id: id}}, %{advisors: advisors}) do
    advice_requests =
      Enum.map(advisors, fn advisor ->
        %{questionnaire_id: id, advisor_id: advisor}
      end)

    case Repo.insert_all(Advice, advice_requests, returning: true) do
      {_, advisories} -> {:ok, advisories}
      error -> error
    end
  end
end
