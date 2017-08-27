defmodule AdvisorWeb.HealthcheckController do
  use AdvisorWeb, :controller
  alias __MODULE__.Git

  defmodule Git do
    def current_git_sha() do
      heroku_sha() || system_sha()
    end

    defp heroku_sha() do
      System.get_env("HEROKU_SLUG_COMMIT")
    end

    defp system_sha()  do
      {sha, _} = System.cmd("git", ["rev-parse", "HEAD"])
      String.trim(sha)
    end
  end

  def index(conn, _params) do
    text conn, "Last commit: #{Git.current_git_sha()}"
  end
end
