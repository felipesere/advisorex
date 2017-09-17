defmodule Mix.Tasks.Db do
  use Mix.Task

  @shortdoc "Start the postgres instance"

  @pg_directory "/usr/local/var/postgres"

  def run(_) do
    System.cmd("pg_ctl", ["start", "-D", @pg_directory, "-l", "#{@pg_directory}/server.log"])
  end
end
