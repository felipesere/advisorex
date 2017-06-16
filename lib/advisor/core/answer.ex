defmodule Advisor.Core.Answer do
  use Ecto.Schema

  @only_inserted_at [updated_at: false]

  schema "answers" do
    field :advice_request_id, :binary_id
    field :question_id, :integer
    field :answer, :string
    timestamps(@only_inserted_at)
  end
end
