defmodule Advisor.Core.CreatorTest do
  use ExUnit.Case
  alias Advisor.Core.Creator
  alias Advisor.Web.QuestionnaireProposal

  setup do
    # Explicitly get a connection before each test
    # By default the test is wrapped in a transaction
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Advisor.Repo)

    # The :shared mode allows a process to share 
    # its connection with any other process automatically
    Ecto.Adapters.SQL.Sandbox.mode(Advisor.Repo, { :shared, self() })
  end

  test "creates a simple questionnaire" do
    proposal = %QuestionnaireProposal{group_lead: 1, 
                                      requester: 2,
                                      advisors: [2],
                                      questions: [7] }

    {:ok, s} = Creator.create(proposal)
    assert s.id
  end
end