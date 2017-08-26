defmodule Advisor.Core.Answer do
  use Ecto.Schema

  @only_created_at [updated_at: false]

  schema "answers" do
    field :advice_request_id, :binary_id
    field :question_id, :binary
    field :answer, :string
    timestamps(@only_created_at)
  end
end
