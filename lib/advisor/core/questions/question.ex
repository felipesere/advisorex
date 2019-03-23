defmodule Advisor.Core.Question do
  use Ecto.Schema
  import Ecto.Query
  alias Advisor.Repo
  alias __MODULE__

  @type t :: %__MODULE__{id: String.t(), phrase: String.t()}
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "questions" do
    field(:phrase, :string)
  end

  def store(phrases) do
    phrases = Enum.map(phrases, &%{phrase: &1})

    Question
    |> Repo.insert_all(phrases, returning: true)
    # TODO: Gaaaaaaaaah...
    |> elem(1)
    |> Enum.map(& &1.id)
  end

  # TODO: Load is very vague...
  def load(uuids) do
    Repo.all(from(q in Question, where: q.id in ^uuids))
  end
end
