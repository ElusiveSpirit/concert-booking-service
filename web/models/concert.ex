defmodule ConcertBooking.Concert do
  use ConcertBooking.Web, :model
  use Arc.Ecto.Schema

  schema "concerts" do
    field :name, :string
    field :description, :string
    field :date, Ecto.Date
    field :picture, ConcertBooking.Picture.Type

    many_to_many :users, ConcertBooking.User,
      join_through: "users_concerts"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :date, :picture])
    |> cast_attachments(params, [:picture])
    |> validate_required([:name, :description, :date, :picture])
  end

  def serialize(obj) do
    %{
      "id" => obj.id,
      "name" => obj.name,
      "description" => obj.description,
      "date" => obj.date,
      "picture" => ConcertBooking.Picture.url({obj.picture, obj}, :thumb)
    }
  end
end
