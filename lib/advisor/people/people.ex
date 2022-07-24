defmodule Advisor.People do
  alias Advisor.Person
  alias Advisor.Repo
  alias Advisor.Person
  import Ecto.Query

  def update(person) do
    Repo.update(person)
  end
  def update(email, params) do
    person = find_by(email: email)

    if person do
      changes = Person.changeset(person, params)

      if changes.valid? do
        Repo.update(changes)
        :ok
      else
        changes.errors
      end
    else
      :not_found
    end
  end

  def create(data) do
    person = Person.changeset(%Person{}, data, hash_password: true)

    if person.valid? do
      Repo.insert!(person)

      :ok
    else
      person.errors
    end
  end

  def everybody(), do: Repo.all(from(p in Person, order_by: p.name))

  def mentors(), do: Repo.all(from(p in Person, where: p.is_mentor, order_by: p.name))

  def everybody_but(user) do
    everybody()
    |> Enum.filter(but(user))
  end

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = find_by(email: email)
    if valid_password?(user, password) do
      user
    end
  end

  defp valid_password?(%Advisor.Person{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def find(%{id: id}), do: find_by(id: id)
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

  defp but(user), do: fn person -> person.email != user.email end

  defp query_by_user(id), do: Repo.one(from(p in Person, where: p.id == ^id))

  defp query_by_name(name), do: Repo.one(from(p in Person, where: p.name == ^name))

  defp query_by_email(email), do: Repo.one(from(p in Person, where: p.email == ^email))

  defp parse(user_id) do
    case Integer.parse(user_id) do
      {id, ""} -> id
      _ -> :bad_parse
    end
  end

  def delete([email: email]) do
    from(p in Person, where: p.email == ^email)
    |> Repo.delete_all()
  end
end
