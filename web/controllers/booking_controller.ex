defmodule ConcertBooking.BookingController do
  use ConcertBooking.Web, :controller
  import Ecto.Query, only: [from: 2]

  alias ConcertBooking.Concert


  @doc"""
  Main book func
  """
  def book(conn, %{"concert_id" => concert_id})
  when not is_nil(concert_id) do
    book_handle(conn, concert_id, "create")
  end

  def book(conn, _) do
    failed_booking(conn)
  end


  @doc"""
  Main unbook func
  """
  def unbook(conn, %{"concert_id" => concert_id})
  when not is_nil(concert_id) do
    book_handle(conn, concert_id, "delete")

  end

  def unbook(conn, _) do
    failed_booking(conn)
  end


  @doc"""
  API func for book
  """
  def book_api(conn, %{"json" => json}) do
    book_api(conn, Poison.Parser.parse!(json))
  end

  def book_api(conn, %{"concert_id" => concert_id})
  when not is_nil(concert_id) do
    book_handle_api(conn, concert_id, "create")
  end

  def book_api(conn, _) do
    failed_booking_api(conn)
  end


  @doc"""
  API func for unbook
  """
  def unbook_api(conn, %{"json" => json}) do
    unbook_api(conn, Poison.Parser.parse!(json))
  end

  def unbook_api(conn, %{"concert_id" => concert_id})
  when not is_nil(concert_id) do
    book_handle_api(conn, concert_id, "delete")
  end

  def unbook_api(conn, _) do
    failed_booking_api(conn)
  end


  @doc"""
  Main (un)book request handle
  """
  defp book_handle(conn, concert_id, action) do
    concert = Repo.get!(Concert, concert_id)

    case Guardian.Plug.current_resource(conn) do
      nil  -> failed_booking(conn)
      user ->
        case update_booking(concert, user, action) do
          "create" ->
            conn
            |> put_flash(:info, "You've booked a ticket")
            |> redirect(to: concert_path(conn, :show, concert.id))

          "delete" ->
            conn
            |> put_flash(:info, "You've unbooked a ticket")
            |> redirect(to: concert_path(conn, :show, concert.id))
        end
    end
  end

  @doc"""
  API (un)book request handle
  """
  defp book_handle_api(conn, concert_id, action) do
    concert = Repo.get!(Concert, concert_id)

    case Guardian.Plug.current_resource(conn) do
      nil  -> failed_booking_api(conn)
      user ->
        action = update_booking(concert, user, action)
        [[count]] = Ecto.Adapters.SQL.query!(Repo, "SELECT COUNT(user_id) FROM users_concerts", []).rows
        json conn, %{ "action" => action, "count" => count }
    end
  end


  @doc"""
  Func for working with db
  """
  defp update_booking(concert, user, action) do
    case action do
      "create" ->
        Ecto.Adapters.SQL.query!(Repo,
          "INSERT INTO users_concerts (user_id, concert_id) VALUES ($1, $2)",
          [user.id, concert.id]
        )
        # concert
        # |> Repo.preload(:users)
        # |> Ecto.Changeset.change()
        # |> Ecto.Changeset.put_assoc(:users, [user])
        # |> Repo.update!

      "delete" ->
        Repo.delete_all( from uc in "users_concerts", where: (uc.user_id == ^user.id) and (uc.concert_id == ^concert.id))
    end
    action
  end

  defp failed_booking(conn) do
    conn
    |> put_flash(:error, "Something got wrong")
    |> redirect(to: concert_path(conn, :index))
    |> halt()
  end

  defp failed_booking_api(conn) do
    json conn, %{ "code" => "403", "message" => "Error..." }
  end
end
