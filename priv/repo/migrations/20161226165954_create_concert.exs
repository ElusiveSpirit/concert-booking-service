defmodule ConcertBooking.Repo.Migrations.CreateConcert do
  use Ecto.Migration

  def change do
    create table(:concerts) do
      add :name, :string
      add :description, :text
      add :date, :date
      add :picture, :string

      timestamps()
    end

  end
end
