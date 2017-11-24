defmodule Advisor.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Advisor.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Advisor.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Advisor.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Advisor.Repo, {:shared, self()})
    end

    :ok
  end
end
