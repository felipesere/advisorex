defmodule Advisor.Core.Advice do
  use Ecto.Schema
  alias Advisor.Core.Advice.Finder

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "advice_requests" do
    field :questionnaire_id, :binary_id
    field :requester_id,      :integer
    field :advisor_id,        :integer
  end

  defmodule Advisory do
    defstruct [:advisor, :advice_id]
  end

  defdelegate find(id), to: Finder
  defdelegate find(id, opts), to: Finder
  defdelegate all_for(id), to: Finder
end
