defmodule Mix.Tasks.Advisor.Ci do
  use Mix.Task
  alias Mix.Task

  def run(_) do
    Task.load_all()

    Task.run("test", [])
    Task.run("credo", ["--strict"])

    case System.get_env("CI") do
      nil -> Task.run("coveralls", [])
      "true" -> running_on_travis()
    end
  end

  def running_on_travis() do
    Task.run("coveralls.travis", [])
  end
end
