defmodule AdvisorWeb.LandingPageTest do
  use AdvisorWeb.ConnCase
  import PageAssertions

  test "Hit the landing page", %{conn: conn} do
    conn = get conn, "/"
    response = html_response(conn, 200)

    response
    |> has_title("Advisor")
    |> has_submit_buttons(["Ask for advice", "Go to your Dashboard"])
  end

  def has_submit_buttons(html, buttons) do
    assert html |> Floki.find("button[type=submit]") |> Enum.map(&Floki.text/1) == buttons
    html
  end

  test "No need to login again", %{conn: conn} do
    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("/")
    |> html_response(200)
    |> has_title("Hello Felipe Sere!")
    |> has_submit_buttons(["Ask for advice", "Go to your Dashboard"])
    |> has_no_login()
  end

  test "Can log out if you are logged in", %{conn: conn} do
    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("/")
    |> html_response(200)
    |> has_logout_button()
  end

  test "When the user is bounced back to the login page, that is all they can do", %{conn: conn} do
    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> ThroughTheWeb.tried_to_access("/flubber")
    |> get("/")
    |> html_response(200)
    |> has_submit_buttons(["Login"])
  end

  def has_no_login(html) do
    assert html |> Floki.find("input[type=password]") == []
    assert html |> Floki.find("input[type=email]") == []
    html
  end

  def has_logout_button(html) do
    assert html |> Floki.find(".button.logout") |> length() == 1
  end
end
