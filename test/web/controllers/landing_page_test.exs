defmodule Advisor.Web.LandingPageTest do
  use Advisor.Web.ConnCase
  import PageAssertions

  test "Hit the landing page", %{conn: conn} do
    conn = get conn, "/"
    response = html_response(conn, 200)

    response
    |> has_title("Advisor")
    |> has_buttons(["Ask for advice", "Go to your Dashboard"])
  end

  def has_buttons(html, buttons) do
    assert html |> Floki.find("button") |> Enum.map(&Floki.text/1) == buttons
    html
  end

  test "No need to login again", %{conn: conn} do
    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("/")
    |> html_response(200)
    |> has_title("Hello Felipe Sere!")
    |> has_buttons(["Ask for advice", "Go to your Dashboard"])
    |> has_no_login()
  end

  def has_no_login(html) do
    assert html |> Floki.find("input[type=password]") == []
    assert html |> Floki.find("input[type=email]") == []
    html
  end
end
