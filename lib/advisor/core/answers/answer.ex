defmodule Advisor.Core.Answer do
  alias __MODULE__

  use Ecto.Schema

  @ignored_keys ["id", "_csrf_token"]

  @only_created_at [updated_at: false]

  schema "answers" do
    field(:advice_request_id, :binary_id)
    field(:question_id, :binary)
    field(:answer, :string)
    timestamps(@only_created_at)
  end

  def all_answers_in(params) do
    params
    # this has to be better!
    |> Enum.reject(fn {key, _} -> key in @ignored_keys end)
    |> Enum.map(fn {id, answer} -> %Answer{question_id: id, answer: answer} end)
  end
end
