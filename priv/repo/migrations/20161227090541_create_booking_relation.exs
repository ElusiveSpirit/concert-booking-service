defmodule ConcertBooking.Repo.Migrations.CreateBookingRelation do
  use Ecto.Migration

  def change do
    create table(:users_concerts, primary_key: false) do
      add :user_id, references(:users)
      add :concert_id, references(:concerts)
    end
  end
end
