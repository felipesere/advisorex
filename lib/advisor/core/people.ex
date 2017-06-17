defmodule Advisor.Core.People do
  alias Advisor.Repo
  alias Advisor.Core.Person
  import Ecto.Query

  def find_by_id(id), do: find_by([id: id])

  def find_by([names: names]) when is_list(names) do
    names
    |> Enum.map(&(find_by(name: &1)))
  end
  def find_by([name: name]) do
    Repo.one(from u in Person, where: u.name == ^name)
  end
  def find_by(%{advisor_id: id}), do: find_by_id(id)
  def find_by([email: email]) do
    query = from u in Person,
                where: u.email == ^email

    Repo.one(query)
  end
  def find_by([id: nil]), do: nil
  def find_by([id: id]) when is_integer(id), do: query_by_user(id)
  def find_by([id: id]) do
    case parse(id) do
      :bad_parse -> nil
      id -> query_by_user(id)
    end
  end

  def find_group_lead([name: name]) do
    query = from u in Person, where: u.name == ^name and u.is_group_lead
    Repo.one(query)
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
