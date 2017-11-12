defmodule ThroughTheWeb do
  use Phoenix.ConnTest
  @endpoint AdvisorWeb.Endpoint

  def answer!(conn, links, answers) do
    Enum.each(links, fn (link) ->
      conn
      |> login_as(link.person.name)
      |> post(link.link, answers)
    end)
  end

  def login_as(conn, name) when is_binary(name) do
    person = Advisor.Core.People.find_by(name: name)

    conn
    |> assign(:user_id, person.id)
  end

  def tried_to_access(conn, target) do
    conn
    |> put_session(:target, target)
  end
end
