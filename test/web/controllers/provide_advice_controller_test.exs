defmodule AdvisorWeb.ProvideAdviceControllerTest do
  use AdvisorWeb.ConnCase
  import PageAssertions
  alias Advisor.Test.Support.Sample

  setup do
    advice = Sample.questionnaire()
             |> Sample.advice_from("Rabea Gleissner")

    [advice: advice]
  end

  test "renders the form", %{conn: conn, advice: advice} do
    path = Routes.provide_advice_path(@endpoint, :index, advice.id)

    conn
    |> ThroughTheWeb.login_as("Rabea Gleissner")
    |> get(path)
    |> html_response(200)
    |> has_header("Advice for Chris Jordan")
    |> has_message("This is a random message")
  end

  test "force login if incorrect advisor is authenticated", %{conn: conn, advice: advice} do
    assert conn
           |> ThroughTheWeb.login_as("Priya Patil")
           |> get(Routes.provide_advice_path(@endpoint, :index, advice.id))
           |> redirected_to() == "/"
  end

  test "renders thank you page", %{conn: conn, advice: advice} do
    path = Routes.provide_advice_path(@endpoint, :create, advice.id)

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> post(path)
    |> html_response(200)
    |> has_header("Thank you!")
  end
end
