defmodule ConcertBooking.BookingController do
  use ConcertBooking.Web, :controller
  import Ecto.Query, only: [from: 2]

  alias ConcertBooking.Concert


  def book(conn, params), do: book_handle(conn, params, "create")

  def unbook(conn, params), do: book_handle(conn, params, "delete")

  defp book_handle(conn, %{"concert_id" => concert_id}, action)
  when not is_nil(concert_id) and not is_nil(action) do
    concert = Repo.get!(Concert, concert_id)

    case Guardian.Plug.current_resource(conn) do
      nil  -> failed_booking(conn)
      user -> update_booking(concert, user, action)
    end

    conn
    |> put_flash(:info, "You've booked a ticket")
    |> redirect(to: concert_path(conn, :show, concert.id))
  end

  defp book_handle(conn, _, _) do
    failed_booking(conn)
  end

  defp update_booking(concert, user, action) do
    case action do
      "create" ->
        Ecto.Adapters.SQL.query!(Repo,
          "INSERT INTO users_concerts (user_id, concert_id) VALUES ($1, $2)",
          [user.id, concert.id])
        # concert
        # |> Repo.preload(:users)
        # |> Ecto.Changeset.change()
        # |> Ecto.Changeset.put_assoc(:users, [user])
        # |> Repo.update!

      "delete" ->
        Repo.delete_all( from uc in "users_concerts", where: (uc.user_id == ^user.id) and (uc.concert_id == ^concert.id))
    end
  end

  defp failed_booking(conn) do
    conn
    |> put_flash(:error, "Something got wrong")
    |> redirect(to: concert_path(conn, :index))
    |> halt()
  end
end
