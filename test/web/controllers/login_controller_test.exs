defmodule Advisor.Web.LoginControllerTest do
  use Advisor.Web.ConnCase

  test "Proper login", %{conn: conn} do
    conn = post conn, "/begin", [email: "felipe@example.com"]

    assert redirected_to(conn) =~ "/request"
    assert conn.cookies["user"] == "11"
  end

  test "Fails to login with unkown email", %{conn: conn} do
    conn = post conn, "/begin", [email: "bob@example.com"]

    assert redirected_to(conn) == "/"
    refute conn.cookies["user"]
  end

  test "Redirect to original path if this was a bounced login", %{conn: conn} do
    conn = conn
           |> put_req_cookie("target", "/foo/bar")
           |> post("/begin", [email: "felipe@example.com"])

    assert redirected_to(conn) == "/foo/bar"
  end
end
