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
  end

  defmodule Advisory do
    defstruct [:advisor, :advice_id]
  end

  def all_for(%{id: id}), do: all_for(id)
  def all_for(id) do
    Repo.all(from advice in Advice, where: advice.questionnaire_id == ^id)
  end

  def find(id) do
    Repo.get(Advice, id)
  end

  def find(advice_id, [from_advisor: %{id: advisor_id}]) do
    Repo.one(from a in Advice, where: a.id == ^advice_id and a.advisor_id == ^advisor_id)
  end

  def from_advisor(advisor, [for: requester]) do
    Repo.one(from a in Advice,
             where: a.advisor_id == ^advisor and a.requester_id == ^requester.id)
  end
end
