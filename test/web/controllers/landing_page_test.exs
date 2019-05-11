defmodule AdvisorWeb.LandingPageTest do
  use AdvisorWeb.ConnCase
  alias PageAssertions, as: It
  alias Advisor.Test.Support.{Sample, Users}

  test "Hit the landing page", %{conn: conn} do
    conn
    |> Visit.the(:landing_page)
    |> It.has_title("Advisor")
    |> It.has_link_to("Login with Google")
  end

  test "No need to login again", %{conn: conn} do
    Users.with("Felipe Sere")

    conn
    |> Login.as("Felipe Sere")
    |> Visit.the(:landing_page)
    |> It.has_title("Hello Felipe Sere!")
    |> It.has_links(["Ask for advice", "Go to your Dashboard"])
    |> It.has_no_login()
  end

  test "Can log out if you are logged in", %{conn: conn} do
    Users.with("Felipe Sere")

    conn
    |> Login.as("Felipe Sere")
    |> Visit.the(:landing_page)
    |> It.has_logout_button()
  end

  test "can only have one questionnaire open at a time", %{conn: conn} do
    Sample.questionnaire(for: "Felipe Sere")

    conn
    |> Login.as("Felipe Sere")
    |> Visit.the(:landing_page)
    |> It.has_no_link("Ask for advice")
  end
end
