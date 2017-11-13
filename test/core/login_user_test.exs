defmodule Advisor.Core.LoginUserTest do
  use Advisor.DataCase
  alias Advisor.Core.LoginUser
  alias Advisor.Core.{Person, People}

  test "creates the user if has not logged in before" do
    auth = auth_for("somebody@8thlight.com", "Somebody")
    LoginUser.find_or_create(auth)

    assert People.find_by(email: "somebody@8thlight.com")
  end

  test "just reads the user if they already exist" do
    person = Repo.insert!(%Person{email: "somebody@8thlight.com", name:  "Somebody"})

    auth = auth_for(person.email, person.name)

    assert LoginUser.find_or_create(auth)
  end

  def auth_for(email, name) do
    %Ueberauth.Auth{
      info: %Elixir.Ueberauth.Auth.Info{
         description: nil,
         email: email,
         first_name: "Felipe",
         image: "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg",
         last_name: "Seré",
         location: nil,
         name: name,
         nickname: nil,
         phone: nil,
         urls: %{
           profile: nil,
           website: "8thlight.com",
         }
      }
    }
  end
end
