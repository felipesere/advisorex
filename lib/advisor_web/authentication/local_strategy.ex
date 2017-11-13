defmodule Local.Strategy do
  use Ueberauth.Strategy

  alias Ueberauth.Auth.Info
  alias Ueberauth.Strategy.Helpers

  def handle_request!(conn) do
    redirect!(conn, Helpers.callback_path(conn))
  end

  def info(_conn) do
    %Info{
      urls: %{website: "8thlight.com"},
      email: "rswanson@8thlight.com",
      name: "Ron Swanson"
    }
  end
end
