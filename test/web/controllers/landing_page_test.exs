defmodule AdvisorWeb.LandingPageTest do
  use AdvisorWeb.ConnCase
  import PageAssertions
  alias Advisor.Test.Support.{Sample, Users}

  test "Hit the landing page", %{conn: conn} do
    conn = get conn, "/"
    response = html_response(conn, 200)

    response
    |> has_title("Advisor")
    |> has_link_to("Login with Google")
  end

  def has_submit_buttons(html, buttons) do
    assert html |> Floki.find("button[type=submit]") |> Enum.map(&Floki.text/1) == buttons
    html
  end

  test "No need to login again", %{conn: conn} do
    Users.with("Felipe Sere")

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("/")
    |> html_response(200)
    |> has_title("Hello Felipe Sere!")
    |> has_links(["Ask for advice", "Go to your Dashboard"])
    |> has_no_login()
  end

  test "Can log out if you are logged in", %{conn: conn} do
    Users.with("Felipe Sere")

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("/")
    |> html_response(200)
    |> has_logout_button()
  end

  def has_no_login(html) do
    assert html |> Floki.find(".login") == []
    html
  end

  def has_logout_button(html) do
    assert html |> Floki.find(".button.logout") |> length() == 1
  end

  test "can only have one questionnaire open at a time", %{conn: conn} do
    Sample.questionnaire(for: "Felipe Sere")

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("/")
    |> html_response(200)
    |> has_no_link("Ask for advice")
  end
end
