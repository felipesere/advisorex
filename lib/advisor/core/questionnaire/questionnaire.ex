defmodule Advisor.Core.Questionnaire do
  use Ecto.Schema
  import Ecto.Query
  alias Advisor.Core.{People, Questions}
  alias Advisor.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "questionnaires" do
    field :question_ids, {:array, :integer}
    field :requester_id, :integer
    field :group_lead, :integer
  end

  def form_data() do
    everybody = People.everybody()
    group_leads = Enum.filter(everybody, &who_is_a_group_lead/1)
    questions = Questions.all()

    {everybody, group_leads, questions}
  end

  defp who_is_a_group_lead(person), do: person.is_group_lead

  def for_group_lead(group_lead_id) do
    Repo.all(from q in Questionnaire, where: q.group_lead == ^group_lead_id)
  end

  def find(id) do
    Repo.get(Questionnaire, id)
  end

  defmodule Created do
    defstruct questionnaire: :unassigned, advisories: []
  end
end
