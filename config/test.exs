import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :advisor, AdvisorWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :advisor, Advisor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "advisor_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :advisor, Advisor.Mailer, adapter: Swoosh.Adapters.Test

config :advisor, Advisor.Notifications.Email.Mailer, adapter: Swoosh.Adapters.Test

config :advisor, FeatureToggle, emails: true

config :advisor, AdvisorWeb.AdminController, api_key: "SECRET"
