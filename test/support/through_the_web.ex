defmodule ThroughTheWeb do
  use Phoenix.ConnTest

  def login_as(conn, name) when is_binary(name) do
    person = Advisor.Core.People.find_by(name: name)

    conn
    |> assign(:user_id, person.id)
  end
end
