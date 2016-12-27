defmodule ConcertBooking.ConcertControllerTest do
  use ConcertBooking.ConnCase

  alias ConcertBooking.Concert
  @valid_attrs %{date: %{day: 17, month: 4, year: 2010}, description: "some content", name: "some content", picture: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, concert_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing concerts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, concert_path(conn, :new)
    assert html_response(conn, 200) =~ "New concert"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, concert_path(conn, :create), concert: @valid_attrs
    assert redirected_to(conn) == concert_path(conn, :index)
    assert Repo.get_by(Concert, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, concert_path(conn, :create), concert: @invalid_attrs
    assert html_response(conn, 200) =~ "New concert"
  end

  test "shows chosen resource", %{conn: conn} do
    concert = Repo.insert! %Concert{}
    conn = get conn, concert_path(conn, :show, concert)
    assert html_response(conn, 200) =~ "Show concert"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, concert_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    concert = Repo.insert! %Concert{}
    conn = get conn, concert_path(conn, :edit, concert)
    assert html_response(conn, 200) =~ "Edit concert"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    concert = Repo.insert! %Concert{}
    conn = put conn, concert_path(conn, :update, concert), concert: @valid_attrs
    assert redirected_to(conn) == concert_path(conn, :show, concert)
    assert Repo.get_by(Concert, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    concert = Repo.insert! %Concert{}
    conn = put conn, concert_path(conn, :update, concert), concert: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit concert"
  end

  test "deletes chosen resource", %{conn: conn} do
    concert = Repo.insert! %Concert{}
    conn = delete conn, concert_path(conn, :delete, concert)
    assert redirected_to(conn) == concert_path(conn, :index)
    refute Repo.get(Concert, concert.id)
  end
end
