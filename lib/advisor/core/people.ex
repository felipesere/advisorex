defmodule Advisor.Core.People do
  alias Advisor.Repo
  alias Advisor.Core.Person
  import Ecto.Query

  def find_by_id(id), do: find_by([id: id])

  def find_by([email: email]) do
    query = from u in Person,
                where: u.email == ^email

    Repo.one(query)
  end
  def find_by([id: nil]), do: nil
  def find_by([id: user_id]) do
    case parse(user_id) do
      :bad_parse -> nil
      id -> query_by_user(id)
    end
  end

  defp query_by_user(id), do: Repo.one(from u in Person, where: u.id == ^id)

  defp parse(user_id) do
    case Integer.parse(user_id) do
      {id, ""} -> id
      _ -> :bad_parse
    end
  end

  def everybody() do
    Repo.all(Person)
  end
end
