defmodule Advisor.Core.LoginUser do
  alias Advisor.Core.People

  def find_or_create(%{info: %{email: email, name: name}}) do
    data = %{name: name, email: email}

    case People.find_by(email: email) do
      nil -> People.create(data)
      user -> user
    end
  end
end
