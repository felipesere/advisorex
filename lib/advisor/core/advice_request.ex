defmodule Advisor.Core.AdviceRequest do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "advice_requests" do
    field :questionnaire_id, :binary_id
    field :requester_id,      :integer
    field :advisor_id,        :integer
  end

  defmodule Advisory do
    defstruct [:advisor, :advice_id]
  end
end
