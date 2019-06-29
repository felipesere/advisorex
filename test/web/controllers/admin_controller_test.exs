defmodule AdvisorWeb.AdminControllerTest do
  alias Advisor.Test.Support.Users
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

  test "updates a person's details", %{conn: conn} do
    felipe = Users.with("Felipe Sere")

    updated_conn = conn
                   |> put_req_header("authorization", "Bearer SECRET")
                   |> put("/admin/people/#{felipe.email}", %{name: "Strange name", email: "foo@bar.com"})


    assert response(updated_conn, 200)
    assert People.find_by(email: "foo@bar.com").id == felipe.id
  end

  test "can delete a person", %{conn: conn} do
    felipe = Users.with("Felipe Sere")

    conn
    |> put_req_header("authorization", "Bearer SECRET")
    |> delete("/admin/people/#{felipe.email}")

    refute People.find(felipe)
  end

  test "failures are reported", %{conn: conn} do
    response = conn
               |> put_req_header("authorization", "Bearer SECRET")
               |> post("/admin/people", %{nme: "Lightning McQueen"})
               |> json_response(400)

    assert response == %{"email" => "can't be blank", "name" => "can't be blank"}
  end
end
