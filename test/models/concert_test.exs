defmodule ConcertBooking.ConcertTest do
  use ConcertBooking.ModelCase

  alias ConcertBooking.Concert

  @valid_attrs %{date: %{day: 17, month: 4, year: 2010}, description: "some content", name: "some content", picture: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Concert.changeset(%Concert{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Concert.changeset(%Concert{}, @invalid_attrs)
    refute changeset.valid?
  end
end
