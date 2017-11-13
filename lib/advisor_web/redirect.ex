defmodule AdvisorWeb.Redirect do
  alias Plug.Conn

  def target(conn), do: Conn.get_session(conn, :target)
end
