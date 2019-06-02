defmodule Advisor.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Advisor.Repo, []),
      supervisor(AdvisorWeb.Endpoint, []),
      supervisor(Advisor.Question.PhrasesCatalog, [])
    ]

    opts = [strategy: :one_for_one, name: Advisor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
