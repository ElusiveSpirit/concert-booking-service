defmodule ConcertBooking.Concert do
  use ConcertBooking.Web, :model
  use Arc.Ecto.Schema

  schema "concerts" do
    field :name, :string
    field :description, :string
    field :date, Ecto.Date
    field :picture, ConcertBooking.Picture.Type

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
end
