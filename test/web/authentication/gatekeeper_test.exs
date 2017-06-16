defmodule Advisor.Web.Authentication.GatekeeprTest do
  use Advisor.Web.ConnCase
  alias Advisor.Web.Authentication.Gatekeeper
  alias Advisor.Core.{Person, People}

  @default_opts Gatekeeper.init([])

  test "halts the request if not user_id found in session" do
    conn = build_conn() |> Gatekeeper.call(@default_opts)

    assert conn.status == 302
  end

  test "presrves original destination in session" do
    conn = "/foo"
           |> get()
           |> Gatekeeper.call(@default_opts)
           |> fetch_cookies()

    assert conn.cookies["target"] == "/foo"
  end

  test "loads the user if it available" do
    conn = "/foo"
           |> get()
           |> with_user(name: "Chris Jordan")
           |> Gatekeeper.call(@default_opts)

    assert %Person{} = conn.assigns[:user]
  end

  test "prevents a regular user from accessing a page for group leads" do
    conn = "/foo"
           |> get()
           |> with_user(name: "Chris Jordan")
           |> Gatekeeper.call(:group_leads)

    assert conn.status == 302
  end

  defp with_user(conn, [name: name]) do
    case People.find_by(name: name) do
      nil -> raise "Could not finder user #{name}"
      %{id: id} -> put_req_cookie(conn, "user", Integer.to_string(id))
    end
  end

  defp get(path) do
    build_conn(:get, path, [])
  end
end
