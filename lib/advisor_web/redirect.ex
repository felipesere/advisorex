defmodule AdvisorWeb.Redirect do
  def target(conn), do: Plug.Conn.get_session(conn, :target)
end
