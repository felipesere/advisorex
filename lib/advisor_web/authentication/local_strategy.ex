defmodule Local.Strategy do
  use Ueberauth.Strategy

  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Info

  def handle_request!(conn) do
    redirect!(conn, Ueberauth.Strategy.Helpers.callback_path(conn))
  end

  def info(conn) do
    %Info{
      urls: %{website: "8thlight.com"},
      email: "rswanson@8thlight.com",
      name: "Ron Swanson"
    }
  end
end
