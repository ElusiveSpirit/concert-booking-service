use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :concert_booking, ConcertBooking.Endpoint,
  secret_key_base: "uH3UGmaJQxM82c8o3aTCthgMGJADnFgMTMyEW/7tpxvlBVnqF8L5VujuSX6ny+AH"

# Configure your database
config :concert_booking, ConcertBooking.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "db",
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: "concert_booking_prod",
  pool_size: 20
