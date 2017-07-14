defmodule Mix.Tasks.Password.Generate do
  use Mix.Task
  alias Comeonin.Bcrypt

  @shortdoc "Generates the hash for simple passwords"

  def run(_) do
    password = Mix.Shell.IO.prompt("Enter password that will be hashed:") |> String.trim

    Bcrypt.hashpwsalt(password) |> IO.puts
  end
end
