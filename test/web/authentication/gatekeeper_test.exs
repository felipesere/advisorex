defmodule AdvisorWeb.Authentication.GatekeeprTest do
  use AdvisorWeb.ConnCase
  alias AdvisorWeb.Authentication.Gatekeeper
  alias Advisor.{Person, People}
  alias Plug.Test, as: PlugSupport
  alias Advisor.Test.Support.Users

  @default_opts Gatekeeper.init([])

  setup do
    Users.with("Chris Jordan")

    :ok
  end

  test "halts the request if no user found in session" do
    conn = get("/") |> Gatekeeper.call(@default_opts)

    assert conn.status == 302
  end

  test "preserves original destination in session" do
    conn =
      get("/foo")
      |> Gatekeeper.call(@default_opts)
      |> fetch_session()

    assert get_session(conn, :target) == "/foo"
  end

  test "loads the user if they exist" do
    conn =
      "/foo"
      |> get()
      |> with_user(name: "Chris Jordan")
      |> Gatekeeper.call(@default_opts)

    assert %Person{} = conn.assigns[:user]
  end

  test "prevents a regular user from accessing a page for mentors" do
    opts = Gatekeeper.init(only: :mentors)

    conn =
      "/foo"
      |> get()
      |> with_user(name: "Chris Jordan")
      |> Gatekeeper.call(opts)

    assert conn.status == 302
  end

  test "the redirect can be disabled" do
    opts = Gatekeeper.init(redirect: false)

    conn =
      "/foo"
      |> get()
      |> Gatekeeper.call(opts)

    assert conn.halted == false
  end

  defp with_user(conn, name: name) do
    case People.find_by(name: name) do
      nil -> raise "Could not finder user #{name}"
      %{id: id} -> PlugSupport.init_test_session(conn, %{"user" => Integer.to_string(id)})
    end
  end

  defp get(path) do
    build_conn(:get, path, [])
    |> PlugSupport.init_test_session(%{})
  end
end
