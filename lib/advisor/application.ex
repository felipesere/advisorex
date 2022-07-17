defmodule Advisor.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Advisor.Repo, []},
      # Start the PubSub system
      {Phoenix.PubSub, name: Advisor.PubSub},
      {AdvisorWeb.Endpoint, []},
      {Advisor.Question.PhrasesCatalog, []},
    ]

    opts = [strategy: :one_for_one, name: Advisor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
