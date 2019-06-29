defmodule AdvisorWeb.AuthenticationControllerTest do
  use AdvisorWeb.ConnCase
  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth
  alias AdvisorWeb.AuthenticationController
  alias Advisor.People

  test "successful when user found in database", %{conn: conn} do
    conn = conn |> Plug.Test.init_test_session(target: "/far-away")

    Advisor.Test.Support.Users.with("Felipe Sere")

    assert conn
           |> assign(:ueberauth_auth, %Auth{info: %Info{email: "felipe@example.com", name: "Foo Example"}})
           |> AuthenticationController.callback("empty-params")
           |> redirected_to() == "/far-away"
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
