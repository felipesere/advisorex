defmodule Advisor.Web.Authentication.GatekeeprTest do
  use Advisor.Web.ConnCase
  alias Advisor.Web.Authentication.Gatekeeper
  alias Advisor.Core.Person


  test "halts the request if not user_id found in session" do
    conn = build_conn() |> Gatekeeper.call(%{})

    assert conn.status == 302
  end

  test "presrves original destination in session" do
    conn = get("/foo")
           |> Gatekeeper.call(%{})
           |> fetch_cookies()

    assert conn.cookies["target"] == "/foo"
  end

  test "loads the user if it available" do
    conn = get("/foo")
           |> with_user("11")
           |> Gatekeeper.call(%{})

    assert %Person{} = conn.assigns[:user]
  end

  defp with_user(conn, id) do
    conn
    |> put_req_cookie("user", id)
  end

  defp get(path) do
    build_conn(:get, path, [])
  end
end
