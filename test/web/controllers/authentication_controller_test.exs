defmodule AdvisorWeb.AuthenticationControllerTest do
  use AdvisorWeb.ConnCase
  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth
  alias AdvisorWeb.AuthenticationController
  alias Advisor.Core.People

  test "successful login creates user in the database", %{conn: conn} do
    info = %Info{email: "foo@example.com", name: "Foo Example", urls: %{website: "8thlight.com"}}

    conn
    |> assign(:ueberauth_auth, %Auth{info: info})
    |> AuthenticationController.callback("empty-params")

    assert People.find_by(email: "foo@example.com")
  end

  test "unsuccesful logins just bounce back to the login page", %{conn: conn} do
    info = %Info{
      email: "foo@example.com",
      name: "Foo Example",
      urls: %{website: "not-8thlight.com"}
    }

    assert conn
           |> assign(:ueberauth_auth, %Auth{info: info})
           |> AuthenticationController.callback("empty-params")
           |> redirected_to() == "/"

    refute People.find_by(email: "foo@example.com")
  end
end
