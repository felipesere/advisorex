defmodule AdvisorWeb.Authentication.User do
  def of(conn) do
    conn.assigns[:user]
  end

  def found_in(conn), do: of(conn)
  def extract(conn), do: of(conn)
end
