defmodule Advisor.Core.Questionnaire do
  use Ecto.Schema
  alias Advisor.Core.{People, Questions}
  alias Advisor.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "questionnaires" do
    field :question_ids, {:array, :integer}
    field :requester_id, :integer
  end

  def form_data() do
    everybody = People.everybody()
    group_leads = Enum.filter(everybody, &who_is_a_group_lead/1)
    questions = Questions.all()

    {everybody, group_leads, questions}
  end

  defp who_is_a_group_lead(person), do: person.is_group_lead

  defmodule Created do
    defstruct questionnaire: :unassigned, advisories: []
  end

  def find(id) do
    Repo.get(Questionnaire, id)
  end
end
