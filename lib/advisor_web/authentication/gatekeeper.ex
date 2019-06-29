defmodule AdvisorWeb.Authentication.Gatekeeper do
  import Plug.Conn
  alias Advisor.{Person, People}
  import Phoenix.Controller, only: [redirect: 2]


  def init(opts) do
    allowed_role = Keyword.get(opts, :only, :regular)
    redirect = Keyword.get(opts, :redirect, "/")

    token = :advisor
            |> Application.get_env(AdvisorWeb.AdminController, [])
            |> Keyword.fetch!(:api_key)

    %{only: allowed_role, redirect: redirect, token: token}
  end

  def call(conn, %{only: :admin, token: token}) do
    if authenticated?(conn, token) do
      conn
    else
      unauthorized(conn)
    end
  end

  def call(conn, opts) do
    conn
    |> user_id()
    |> People.find()
    |> preload(conn, opts)
  end

  defp user_id(conn) do
    conn.assigns[:user_id] || from_session(conn)
  end

  defp from_session(conn) do
    conn
    |> fetch_session()
    |> get_session(:user)
  end

  defp preload(%Person{} = user, conn, %{only: :regular}) do
    assign(conn, :user, user)
  end

  defp preload(%Person{is_mentor: true} = user, conn, %{only: :mentors}) do
    assign(conn, :user, user)
  end

  defp preload(_, conn, %{redirect: false}) do
    conn
  end

  defp preload(_, conn, _) do
    conn
    |> redirect_to_login
  end

  defp redirect_to_login(conn) do
    conn
    |> preserve_original_destination
    |> redirect(to: "/")
    |> halt()
  end

  defp preserve_original_destination(conn) do
    conn
    |> put_session(:target, conn.request_path)
  end

  def authenticated?(conn, access_token) do
    token =
      conn
      |> get_req_header("authorization")
      |> parse()

    token == access_token
  end

  def parse(["Bearer " <> token]), do: token
  def parse(_), do: :unauthorized

  def unauthorized(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end
