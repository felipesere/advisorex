defmodule Login do
  def as(conn, %{name: name}), do: as(conn, name)

  def as(conn, name) do
    person = Advisor.People.find_by(name: name)

    Plug.Conn.assign(conn, :user_id, person.id)
  end
end
