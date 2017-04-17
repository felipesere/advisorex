defmodule Advisor.Core.People do
  alias Advisor.Repo
  alias Advisor.Core.Person
  import Ecto.Query

  def find_by([email: email]) do
    query = from u in Person,
                where: u.email == ^email

    Repo.one(query)
  end
end
