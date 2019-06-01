use Mix.Config

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
  password: "",
  database: "advisor_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :advisor, Advisor.Notifications.Email.Mailer, adapter: Bamboo.TestAdapter

config :advisor, FeatureToggle, emails: true
