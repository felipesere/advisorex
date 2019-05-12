defmodule Advisor.Core.People do
  alias Advisor.Repo
  alias Advisor.Core.Person
  import Ecto.Query
  import Ecto.Changeset

  def update(person) do
    Repo.update(person)
  end

  def create(data) do
    %Person{}
    |> cast(data, [:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> Repo.insert!()
  end

  def everybody(), do: Repo.all(from(p in Person, order_by: p.name))

  def mentors(), do: Repo.all(from(p in Person, where: p.is_mentor, order_by: p.name))

  def everybody_but(user) do
    everybody()
    |> Enum.filter(but(user))
  end

  defp but(user), do: fn person -> person.email != user.email end

  def find(id), do: find_by(id: id)

  def find_by(name: name), do: query_by_name(name)
  def find_by(email: email), do: query_by_email(email)
  def find_by(id: id) when is_integer(id), do: query_by_user(id)
  def find_by(id: id) when is_binary(id) do
    case parse(id) do
      :bad_parse -> nil
      id -> query_by_user(id)
    end
  end
  def find_by(_), do: nil

  defp query_by_user(id), do: Repo.one(from(p in Person, where: p.id == ^id))

  defp query_by_name(name), do: Repo.one(from(p in Person, where: p.name == ^name))

  defp query_by_email(email), do: Repo.one(from(p in Person, where: p.email == ^email))

  defp parse(user_id) do
    case Integer.parse(user_id) do
      {id, ""} -> id
      _ -> :bad_parse
    end
  end
end
