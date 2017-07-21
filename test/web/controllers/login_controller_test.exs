defmodule Advisor.Web.LoginControllerTest do
  use Advisor.Web.ConnCase

  test "Proper login to request page", %{conn: conn} do
    conn = post conn, "/begin", [email: "felipe@example.com", password: "secret", submit: "advice"]

    assert redirected_to(conn) =~ "/request"
    assert conn.cookies["user"] == "11"
  end

  test "Login to the dashboard", %{conn: conn} do
    conn = post conn, "/begin", [email: "felipe@example.com", password: "secret", submit: "dashboard"]

    assert redirected_to(conn) =~ "/dashboard"
    assert conn.cookies["user"] == "11"
  end

  test "Fails to login with unkown email", %{conn: conn} do
    conn = post conn, "/begin", [email: "bob@example.com", password: "secret", submit: "advice"]

    assert redirected_to(conn) == "/"
    refute conn.cookies["user"]
  end

  test "Fails to login with wrong email", %{conn: conn} do
    conn = post conn, "/begin", [email: "felipe@example.com", password: "not-secret", submit: "advice"]

    assert redirected_to(conn) == "/"
    refute conn.cookies["user"]
  end

  test "Redirect to original path if this was a bounced login", %{conn: conn} do
    conn = conn
           |> put_req_cookie("target", "/foo/bar")
           |> post("/begin", [email: "felipe@example.com", password: "secret", submit: "redirect"])

    assert redirected_to(conn) == "/foo/bar"
  end

  test "Can log out a user", %{conn: conn} do
    conn = conn
           |> ThroughTheWeb.login_as("Felipe Sere")
           |> get("/logout")

    assert redirected_to(conn) == "/"
    assert conn.cookies["user"] == "deleted"
  end
end
