defmodule Advisor.Web.HealthcheckController do
  use Advisor.Web, :controller
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

  @git_sha Git.current_git_sha()

  def index(conn, _params) do
    text conn, "Last commit: #{@git_sha}"
  end
end
