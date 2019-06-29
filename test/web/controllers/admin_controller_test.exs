defmodule AdvisorWeb.AdminControllerTest do
  use AdvisorWeb.ConnCase
  alias Advisor.People

  test "creates a new person", %{conn: conn} do
    conn
    |> post("/admin/people", %{name: "Lightning McQueen", email: "lightning@mcqueen.com"})


    assert People.find_by(email: "lightning@mcqueen.com")
  end

  test "failures are reported", %{conn: conn} do
    response = conn
               |> post("/admin/people", %{nme: "Lightning McQueen"})
               |> json_response(400)

    assert response == %{"email" => "can't be blank", "name" => "can't be blank"}
  end
end
