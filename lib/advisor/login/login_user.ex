defmodule Advisor.LoginUser do
  alias Advisor.People

  def find_or_create(%{info: %{email: email, name: name}}) do
    data = %{name: name, email: email}

    case People.find_by(email: email) do
      nil -> People.create(data)
      user -> user
    end
  end
end
