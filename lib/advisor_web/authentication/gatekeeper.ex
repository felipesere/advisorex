defmodule AdvisorWeb.Authentication.Gatekeeper do
  import Plug.Conn
  alias Advisor.Core.People
  alias Advisor.Core.Person
  import Phoenix.Controller, only: [redirect: 2]

  def init(opts) do
    allowed_role = Keyword.get(opts, :only, :regular)
    redirect = Keyword.get(opts, :redirect, "/")

    %{only: allowed_role, redirect: redirect}
  end

  def call(conn, opts) do
    conn
    |> user_id()
    |> People.find_by_id()
    |> preload(conn, opts)
  end

  def user_id(conn) do
    conn.assigns[:user_id] || from_session(conn)
  end

  defp from_session(conn) do
    conn
    |> fetch_session()
    |> get_session(:user)
  end

  def preload(%Person{} = user, conn, %{only: :regular}) do
    assign(conn, :user, user)
  end
  def preload(%Person{is_group_lead: true} = user, conn, %{only: :group_leads}) do
    assign(conn, :user, user)
  end
  def preload(_, conn, %{redirect: false}) do
    conn
  end
  def preload(_, conn, _) do
    conn
    |> redirect_to_login
  end

  def redirect_to_login(conn) do
    conn
    |> preserve_original_destination
    |> redirect(to: "/")
    |> halt()
  end

  defp preserve_original_destination(conn) do
    conn
    |> put_session(:target, conn.request_path)
  end
end
