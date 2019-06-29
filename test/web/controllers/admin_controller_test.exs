defmodule AdvisorWeb.AdminControllerTest do
  use AdvisorWeb.ConnCase
  alias Advisor.People

  test "needs to be authenticated", %{conn: conn} do
    conn = conn
           |> put_req_header("authorization", "Bearer NOT-SECRET")
           |> post("/admin/people", %{name: "a", email: "b"})


    assert response(conn, 401)
  end

  test "creates a new person", %{conn: conn} do
    conn
    |> put_req_header("authorization", "Bearer SECRET")
    |> post("/admin/people", %{name: "Lightning McQueen", email: "lightning@mcqueen.com"})


    assert People.find_by(email: "lightning@mcqueen.com")
  end

  test "failures are reported", %{conn: conn} do
    response = conn
               |> put_req_header("authorization", "Bearer SECRET")
               |> post("/admin/people", %{nme: "Lightning McQueen"})
               |> json_response(400)

    assert response == %{"email" => "can't be blank", "name" => "can't be blank"}
  end

  test "can delete a person", %{conn: conn} do
    felipe = Advisor.Test.Support.Users.with("Felipe Sere")

    conn
    |> put_req_header("authorization", "Bearer SECRET")
    |> delete("/admin/people/#{felipe.email}")

    refute People.find(felipe)
  end
end
