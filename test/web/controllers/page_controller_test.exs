defmodule Advisor.Web.LandingPageTest do
  use Advisor.Web.ConnCase

  test "Hit the landing page", %{conn: conn} do
    conn = get conn, "/"
    response = html_response(conn, 200)

    assert Floki.find(response, "h1") |> Floki.text == "Advisor"
    assert Floki.find(response, "button") |> Floki.text == "Ask for advice"
  end

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
end
