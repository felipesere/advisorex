defmodule Mix.Tasks.Password.Generate do
  use Mix.Task
  alias Comeonin.Bcrypt

  @shortdoc "Generates the hash for simple passwords"

  def run(_) do
    password = Mix.Shell.IO.prompt("Enter password that will be hashed:") |> String.trim

    hash = Bcrypt.hashpwsalt(password)
    case Mix.Shell.IO.prompt("Set on heroku? [Y|n]") |> String.trim do
      answer when answer in ["Y", "y", ""] -> set_on_heroku(hash)
      _ -> print_to_shell(hash)
    end
  end

  def print_to_shell(hash), do: IO.puts(hash)

  def set_on_heroku(hash) do
    System.cmd("heroku", ["config:set", "PASSWORD=#{hash}"])
  end
end
