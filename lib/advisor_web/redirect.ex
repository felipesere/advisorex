defmodule AdvisorWeb.Redirect do
  def target("deleted"), do: false
  def target(nil), do: false
  def target(%Plug.Conn{} = conn), do: Plug.Conn.get_session(conn, :target)
  def target(target) when is_binary(target), do: target
end
