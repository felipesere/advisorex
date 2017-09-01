# TODO: This needs to go somewhere...
defmodule AdvisorWeb.Redirect do
  def target(%Plug.Conn{} = conn), do: target(conn.cookies["target"])
  def target(nil), do: false
  def target("deleted"), do: false
  def target(target) when is_binary(target), do: target
end
